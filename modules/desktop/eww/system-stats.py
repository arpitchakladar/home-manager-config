#!/usr/bin/env python3
"""system-stats: emit {cpu, ram, net} as JSON.

net is now an object: {
    "status": "up"|"limited"|"down",
    "type": "wifi"|"ethernet"|None,
    "iface": "wlan0"|None,
    "speed": 866|None,       # link speed in Mbps
    "rx": "12.5M"|None,      # formatted download throughput rate (B/K/M/G)
    "tx": "540K"|None        # formatted upload throughput rate (B/K/M/G)
}

Requires `iw` (for wifi link speed) and `iproute2` (for route lookup) on PATH.
"""
import json
import os
import subprocess
import threading
import time

STATE_LOCK = threading.Lock()
STATE = {
    "cpu": 0,
    "ram": 0,
    "net": {
        "status": "down",
        "type": None,
        "iface": None,
        "speed": None,
        "rx": None,
        "tx": None,
    },
}

# Module-level counters for network byte delta calculations
NET_LAST_TIME = None
NET_LAST_BYTES = {}  # {iface: (rx_bytes, tx_bytes)}


def format_rate(bytes_per_sec):
    """Format bytes/sec into a ultra-compact 3-5 character string (e.g., '500B', '1.2M')."""
    if bytes_per_sec is None or bytes_per_sec < 0:
        return "0B"
    
    units = ["B", "K", "M", "G", "T"]
    val = float(bytes_per_sec)
    unit_idx = 0
    
    while val >= 1024 and unit_idx < len(units) - 1:
        val /= 1024.0
        unit_idx += 1
        
    unit = units[unit_idx]
    
    if val >= 100 or unit == "B":
        return f"{int(val)}{unit}"
    elif val >= 10:
        return f"{val:.1f}{unit}"
    else:
        return f"{val:.1f}{unit}"


def get_iface_io_bytes(iface):
    """Read cumulative rx/tx bytes for a specific interface from /proc/net/dev."""
    if not iface:
        return None, None
    try:
        with open("/proc/net/dev") as f:
            for line in f:
                if ":" not in line:
                    continue
                dev, data = line.split(":", 1)
                if dev.strip() == iface:
                    fields = data.split()
                    return int(fields[0]), int(fields[8])
    except (OSError, ValueError, IndexError):
        pass
    return None, None


def read_cpu_times():
    with open("/proc/stat") as f:
        parts = f.readline().split()[1:]
    vals = list(map(int, parts))
    idle = vals[3] + vals[4]  # idle + iowait
    total = sum(vals)
    return idle, total


def cpu_ram_loop(interval=2.0):
    prev_idle, prev_total = read_cpu_times()
    while True:
        time.sleep(interval)
        
        # Calculate CPU usage
        idle, total = read_cpu_times()
        d_idle = idle - prev_idle
        d_total = total - prev_total
        prev_idle, prev_total = idle, total
        cpu_pct = round((1 - d_idle / d_total) * 100) if d_total else 0

        # Calculate RAM usage
        with open("/proc/meminfo") as f:
            meminfo = {}
            for line in f:
                k, v, *_ = line.split()
                meminfo[k.rstrip(":")] = int(v)
        total_kb = meminfo["MemTotal"]
        avail_kb = meminfo["MemAvailable"]
        ram_pct = round((1 - avail_kb / total_kb) * 100) if total_kb else 0

        # Refresh network metrics on the main ticker (for live throughput)
        net_status = check_net_status()

        with STATE_LOCK:
            STATE["cpu"] = cpu_pct
            STATE["ram"] = ram_pct
            STATE["net"] = net_status
        emit()


def get_default_iface():
    """Interface carrying the default route, or None."""
    try:
        out = subprocess.check_output(
            ["ip", "-o", "route", "show", "default"],
            text=True, stderr=subprocess.DEVNULL,
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        return None
    for line in out.splitlines():
        parts = line.split()
        if "dev" in parts:
            return parts[parts.index("dev") + 1]
    return None


def get_operstate(iface):
    try:
        with open(f"/sys/class/net/{iface}/operstate") as f:
            return f.read().strip()
    except OSError:
        return "down"


def get_iface_type(iface):
    if os.path.exists(f"/sys/class/net/{iface}/wireless"):
        return "wifi"
    if os.path.isdir(f"/sys/class/net/{iface}/bridge"):
        return "bridge"
    if os.path.exists(f"/sys/class/net/{iface}/tun_flags"):
        return "tun"
    return "ethernet"


def get_speed_mbps(iface, iftype):
    if iftype == "ethernet":
        try:
            with open(f"/sys/class/net/{iface}/speed") as f:
                return int(f.read().strip())
        except (OSError, ValueError):
            return None
    if iftype == "wifi":
        try:
            out = subprocess.check_output(
                ["iw", "dev", iface, "link"],
                text=True, stderr=subprocess.DEVNULL,
            )
        except (subprocess.CalledProcessError, FileNotFoundError):
            return None
        for line in out.splitlines():
            line = line.strip()
            if line.startswith("tx bitrate:"):
                try:
                    return round(float(line.split(":", 1)[1].split()[0]))
                except (IndexError, ValueError):
                    return None
    return None


def check_net_status():
    global NET_LAST_TIME, NET_LAST_BYTES

    iface = get_default_iface()
    now = time.monotonic()

    if not iface:
        NET_LAST_TIME = now
        NET_LAST_BYTES = {}
        return {
            "status": "down",
            "type": None,
            "iface": None,
            "speed": None,
            "rx": None,
            "tx": None,
        }

    oper = get_operstate(iface)
    if oper == "up":
        status = "up"
    elif oper == "dormant":
        status = "limited"
    else:
        status = "down"

    iftype = get_iface_type(iface)
    speed = get_speed_mbps(iface, iftype) if status != "down" else None

    # Calculate throughput rate (bytes/sec)
    rx_bytes, tx_bytes = get_iface_io_bytes(iface)
    rx_str, tx_str = "0B", "0B"

    if status != "down" and rx_bytes is not None and tx_bytes is not None:
        if NET_LAST_TIME is not None and iface in NET_LAST_BYTES:
            dt = now - NET_LAST_TIME
            if dt > 0:
                prev_rx, prev_tx = NET_LAST_BYTES[iface]
                rx_rate = max(0, (rx_bytes - prev_rx) / dt)
                tx_rate = max(0, (tx_bytes - prev_tx) / dt)
                rx_str = format_rate(rx_rate)
                tx_str = format_rate(tx_rate)
        NET_LAST_BYTES[iface] = (rx_bytes, tx_bytes)
    else:
        rx_str, tx_str = None, None

    NET_LAST_TIME = now

    return {
        "status": status,
        "type": iftype,
        "iface": iface,
        "speed": speed,
        "rx": rx_str,
        "tx": tx_str,
    }


def net_loop():
    """Event-driven listener for link state transitions."""
    proc = subprocess.Popen(
        ["inotifywait", "-m", "-e", "modify", "/run/systemd/netif/state"],
        stdout=subprocess.PIPE, text=True, bufsize=1,
    )
    for _ in proc.stdout:
        with STATE_LOCK:
            STATE["net"] = check_net_status()
        emit()


def emit():
    with STATE_LOCK:
        print(json.dumps(STATE), flush=True)


def main():
    # Initial state calculation before loop
    with STATE_LOCK:
        STATE["net"] = check_net_status()
    emit()

    threading.Thread(target=cpu_ram_loop, daemon=True).start()
    threading.Thread(target=net_loop, daemon=True).start()
    threading.Event().wait()


if __name__ == "__main__":
    main()
