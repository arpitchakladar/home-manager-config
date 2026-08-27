#!/usr/bin/env python3
"""system-stats: emit {cpu, ram, net} as JSON.

cpu is now an object: {
    "percent": 23,             # overall utilization, 0-100
    "per_core": [12, 34, ...], # per-core utilization, 0-100 each
    "freq_mhz": 2400,          # average current frequency across cores
    "load_avg": [0.5, 0.6, 0.7]  # 1/5/15 min load averages
}

ram is now an object: {
    "percent": 42,             # used %, based on MemAvailable
    "used": "6.2G",            # formatted absolute used
    "total": "16.0G",          # formatted absolute total
    "available": "9.8G",       # formatted absolute available
    "swap_percent": 5,
    "swap_used": "512M",
    "swap_total": "8.0G",
    "speed_mhz": 3200          # configured RAM speed, or null if unavailable
}

net is an object: {
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
RAM speed detection requires `dmidecode`, which typically needs root privileges
(run as root, grant CAP_SYS_RAWIO, or add a passwordless sudo rule) — if it's
unavailable or unreadable, "speed_mhz" is simply reported as null.
"""
import json
import os
import subprocess
import threading
import time

STATE_LOCK = threading.Lock()
STATE = {
    "cpu": {
        "percent": 0,
        "per_core": [],
        "freq_mhz": None,
        "load_avg": None,
        "tooltip": "CPU: 0%",
    },
    "ram": {
        "percent": 0,
        "used": "0B",
        "total": "0B",
        "available": "0B",
        "swap_percent": 0,
        "swap_used": "0B",
        "swap_total": "0B",
        "speed_mhz": None,
        "tooltip": "RAM: 0%",
    },
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


def format_bytes(kib):
    """Format an absolute value given in KiB into a compact human-readable
    string (e.g., '6.2G', '512M'). Same style as format_rate, but for
    absolute quantities rather than a per-second rate."""
    if kib is None or kib < 0:
        return "0B"

    units = ["K", "M", "G", "T"]
    val = float(kib)
    unit_idx = 0

    while val >= 1024 and unit_idx < len(units) - 1:
        val /= 1024.0
        unit_idx += 1

    unit = units[unit_idx]

    if val >= 100 or unit == "K":
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
    """Return {'cpu': (idle, total), 'cpu0': (idle, total), ...} for the
    aggregate and every individual core, parsed from /proc/stat."""
    times = {}
    with open("/proc/stat") as f:
        for line in f:
            if not line.startswith("cpu"):
                break
            parts = line.split()
            label = parts[0]
            vals = list(map(int, parts[1:]))
            idle = vals[3] + vals[4]
            total = sum(vals)
            times[label] = (idle, total)
    return times


def get_cpu_freq_mhz():
    """Average current CPU frequency (MHz) across cores, from /proc/cpuinfo."""
    freqs = []
    try:
        with open("/proc/cpuinfo") as f:
            for line in f:
                if line.lower().startswith("cpu mhz"):
                    try:
                        freqs.append(float(line.split(":", 1)[1].strip()))
                    except ValueError:
                        pass
    except OSError:
        pass
    if not freqs:
        return None
    return round(sum(freqs) / len(freqs))


def get_load_avg():
    try:
        with open("/proc/loadavg") as f:
            parts = f.read().split()
        return [float(parts[0]), float(parts[1]), float(parts[2])]
    except (OSError, ValueError, IndexError):
        return None


def get_ram_speed_mhz():
    """Query DMI tables (SMBIOS type 17) for the configured/current memory
    speed via dmidecode. Requires root — returns None if dmidecode is
    missing, unreadable (permission denied), or reports no populated slots.
    This only needs to be queried once at startup since it doesn't change."""
    try:
        out = subprocess.check_output(
            ["dmidecode", "-t", "17"], text=True, stderr=subprocess.DEVNULL
        )
    except (subprocess.CalledProcessError, FileNotFoundError, PermissionError):
        return None

    speeds = []
    for line in out.splitlines():
        line = line.strip()
        if line.startswith("Configured Memory Speed:"):
            val = line.split(":", 1)[1].strip()
            if val.lower() in ("unknown", "no module installed"):
                continue
            try:
                speeds.append(int(val.split()[0]))
            except (ValueError, IndexError):
                continue

    if not speeds:
        # Fall back to rated "Speed" if no configured speed was reported
        for line in out.splitlines():
            line = line.strip()
            if line.startswith("Speed:"):
                val = line.split(":", 1)[1].strip()
                if val.lower() in ("unknown", "no module installed"):
                    continue
                try:
                    speeds.append(int(val.split()[0]))
                except (ValueError, IndexError):
                    continue

    return max(speeds) if speeds else None


def build_cpu_tooltip(overall_pct, per_core_list, freq_mhz, load_avg):
    lines = [f"CPU: {overall_pct}%"]
    if freq_mhz is not None:
        lines.append(f"Freq: {freq_mhz} MHz")
    if load_avg is not None:
        l1, l5, l15 = load_avg
        lines.append(f"Load: {l1:.2f} {l5:.2f} {l15:.2f}")
    for i, pct in enumerate(per_core_list):
        lines.append(f"Core {i}: {pct}%")
    return "\n".join(lines)


def build_ram_tooltip(ram_pct, used, total, available, swap_pct, swap_used, swap_total, speed_mhz):
    lines = [f"RAM: {ram_pct}% ({used} / {total})"]
    lines.append(f"Available: {available}")
    lines.append(f"Swap: {swap_pct}% ({swap_used} / {swap_total})")
    lines.append(f"Speed: {speed_mhz} MHz" if speed_mhz is not None else "Speed: unknown")
    return "\n".join(lines)


def cpu_ram_loop(interval=2.0):
    prev_times = read_cpu_times()
    # Static for the life of the process — no need to shell out every tick.
    ram_speed_mhz = get_ram_speed_mhz()

    while True:
        time.sleep(interval)

        # --- CPU ---
        cur_times = read_cpu_times()
        overall_pct = 0
        per_core = {}
        for label, (idle, total) in cur_times.items():
            prev_idle, prev_total = prev_times.get(label, (idle, total))
            d_idle = idle - prev_idle
            d_total = total - prev_total
            pct = round((1 - d_idle / d_total) * 100) if d_total else 0
            if label == "cpu":
                overall_pct = pct
            else:
                per_core[int(label[len("cpu"):])] = pct
        prev_times = cur_times
        per_core_list = [per_core[i] for i in sorted(per_core)]

        freq_mhz = get_cpu_freq_mhz()
        load_avg = get_load_avg()
        cpu_state = {
            "percent": overall_pct,
            "per_core": per_core_list,
            "freq_mhz": freq_mhz,
            "load_avg": load_avg,
            "tooltip": build_cpu_tooltip(overall_pct, per_core_list, freq_mhz, load_avg),
        }

        # --- RAM ---
        with open("/proc/meminfo") as f:
            meminfo = {}
            for line in f:
                k, v, *_ = line.split()
                meminfo[k.rstrip(":")] = int(v)

        total_kb = meminfo.get("MemTotal", 0)
        avail_kb = meminfo.get("MemAvailable", 0)
        used_kb = max(0, total_kb - avail_kb)
        ram_pct = round((1 - avail_kb / total_kb) * 100) if total_kb else 0

        swap_total_kb = meminfo.get("SwapTotal", 0)
        swap_free_kb = meminfo.get("SwapFree", 0)
        swap_used_kb = max(0, swap_total_kb - swap_free_kb)
        swap_pct = round((swap_used_kb / swap_total_kb) * 100) if swap_total_kb else 0

        used_fmt = format_bytes(used_kb)
        total_fmt = format_bytes(total_kb)
        avail_fmt = format_bytes(avail_kb)
        swap_used_fmt = format_bytes(swap_used_kb)
        swap_total_fmt = format_bytes(swap_total_kb)
        ram_state = {
            "percent": ram_pct,
            "used": used_fmt,
            "total": total_fmt,
            "available": avail_fmt,
            "swap_percent": swap_pct,
            "swap_used": swap_used_fmt,
            "swap_total": swap_total_fmt,
            "speed_mhz": ram_speed_mhz,
            "tooltip": build_ram_tooltip(
                ram_pct, used_fmt, total_fmt, avail_fmt,
                swap_pct, swap_used_fmt, swap_total_fmt, ram_speed_mhz,
            ),
        }

        # --- Network ---
        net_status = check_net_status()

        with STATE_LOCK:
            STATE["cpu"] = cpu_state
            STATE["ram"] = ram_state
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
