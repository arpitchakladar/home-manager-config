#!/usr/bin/env python3
"""system-stats: emit {cpu, ram, net} as JSON.

net is now an object: {
    "status": "up"|"limited"|"down",
    "tooltip": "↓12M ↑5M\\nwlan0: 192.168.1.5",
    "routes": [
        {
            "iface": "wlan0",
            "ip": "192.168.1.5",
            "type": "wifi",
            "speed": 866,        # link speed in Mbps
            "rx": "12.5M",       # formatted download rate
            "tx": "540K"         # formatted upload rate
        },
        ...
    ]
}

Requires `iw` (for wifi link speed) and `iproute2` (for route/ip lookup) on PATH.
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
        "tooltip": "Network Offline",
        "routes": [],
    },
}

# Module-level tracking for throughput calculations
NET_LAST_TIME = None
NET_LAST_BYTES = {}  # {iface: (rx_bytes, tx_bytes)}


def format_rate(bytes_per_sec):
    """Format bytes/sec into an ultra-compact 3-5 character string (e.g., '500B', '1.2M')."""
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
    idle = vals[3] + vals[4]
    total = sum(vals)
    return idle, total


def cpu_ram_loop(interval=2.0):
    prev_idle, prev_total = read_cpu_times()
    while True:
        time.sleep(interval)
        
        # CPU
        idle, total = read_cpu_times()
        d_idle = idle - prev_idle
        d_total = total - prev_total
        prev_idle, prev_total = idle, total
        cpu_pct = round((1 - d_idle / d_total) * 100) if d_total else 0

        # RAM
        with open("/proc/meminfo") as f:
            meminfo = {}
            for line in f:
                k, v, *_ = line.split()
                meminfo[k.rstrip(":")] = int(v)
        total_kb = meminfo["MemTotal"]
        avail_kb = meminfo["MemAvailable"]
        ram_pct = round((1 - avail_kb / total_kb) * 100) if total_kb else 0

        # Network update
        net_status = check_net_status()

        with STATE_LOCK:
            STATE["cpu"] = cpu_pct
            STATE["ram"] = ram_pct
            STATE["net"] = net_status
        emit()


def get_all_default_ifaces():
    """Returns a list of unique interfaces carrying default routes."""
    try:
        out = subprocess.check_output(
            ["ip", "-o", "route", "show", "default"],
            text=True, stderr=subprocess.DEVNULL,
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        return []
    
    ifaces = []
    for line in out.splitlines():
        parts = line.split()
        if "dev" in parts:
            iface = parts[parts.index("dev") + 1]
            if iface not in ifaces:
                ifaces.append(iface)
    return ifaces


def get_iface_ip(iface):
    """Get the primary IPv4 address for a given interface."""
    if not iface:
        return None
    try:
        out = subprocess.check_output(
            ["ip", "-o", "-4", "addr", "show", "dev", iface],
            text=True, stderr=subprocess.DEVNULL,
        )
        for line in out.splitlines():
            parts = line.split()
            if "inet" in parts:
                cidr = parts[parts.index("inet") + 1]
                return cidr.split("/")[0]
    except (subprocess.CalledProcessError, FileNotFoundError, IndexError):
        pass
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

    ifaces = get_all_default_ifaces()
    now = time.monotonic()

    if not ifaces:
        NET_LAST_TIME = now
        NET_LAST_BYTES = {}
        return {"status": "down", "tooltip": "Network Offline", "routes": []}

    routes = []
    any_up = False
    any_limited = False

    for iface in ifaces:
        oper = get_operstate(iface)
        if oper == "up":
            any_up = True
        elif oper == "dormant":
            any_limited = True

        iftype = get_iface_type(iface)
        ip_addr = get_iface_ip(iface)
        speed = get_speed_mbps(iface, iftype) if oper == "up" else None

        # Live throughput delta calculation per interface
        rx_bytes, tx_bytes = get_iface_io_bytes(iface)
        rx_str, tx_str = "0B", "0B"

        if oper != "down" and rx_bytes is not None and tx_bytes is not None:
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

        routes.append({
            "iface": iface,
            "ip": ip_addr,
            "type": iftype,
            "speed": speed,
            "rx": rx_str,
            "tx": tx_str,
        })

    NET_LAST_TIME = now
    
    # Global status aggregate
    if any_up:
        overall_status = "up"
    elif any_limited:
        overall_status = "limited"
    else:
        overall_status = "down"

    # Build tooltip: first line with speed (rx/tx), then each iface: ip
    if overall_status == "down" or not routes:
        tooltip = "Network Offline"
    else:
        first = routes[0]
        rx = first.get("rx") or "-"
        tx = first.get("tx") or "-"
        tooltip = f"↓{rx} ↑{tx}"
        for r in routes:
            iface = r.get("iface") or "unknown"
            ip = r.get("ip") or "no ip"
            tooltip += f"\n{iface}: {ip}"

    return {"status": overall_status, "tooltip": tooltip, "routes": routes}


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
    with STATE_LOCK:
        STATE["net"] = check_net_status()
    emit()

    threading.Thread(target=cpu_ram_loop, daemon=True).start()
    threading.Thread(target=net_loop, daemon=True).start()
    threading.Event().wait()


if __name__ == "__main__":
    main()
