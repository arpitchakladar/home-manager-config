#!/usr/bin/env python3
"""system-stats: emit {cpu, ram, net} as JSON. CPU/RAM sample on an interval
inside one long-lived process (no per-tick spawn)"""
import json
import subprocess
import threading
import time

STATE_LOCK = threading.Lock()
STATE = {"cpu": 0, "ram": 0, "net": "down"}


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
        idle, total = read_cpu_times()
        d_idle = idle - prev_idle
        d_total = total - prev_total
        prev_idle, prev_total = idle, total
        cpu_pct = round((1 - d_idle / d_total) * 100) if d_total else 0

        with open("/proc/meminfo") as f:
            meminfo = {}
            for line in f:
                k, v, *_ = line.split()
                meminfo[k.rstrip(":")] = int(v)
        total_kb = meminfo["MemTotal"]
        avail_kb = meminfo["MemAvailable"]
        ram_pct = round((1 - avail_kb / total_kb) * 100) if total_kb else 0

        with STATE_LOCK:
            STATE["cpu"] = cpu_pct
            STATE["ram"] = ram_pct
        emit()


def check_net_status() -> str:
    try:
        with open("/run/systemd/netif/state") as f:
            state = dict(
                line.strip().split("=", 1) for line in f if "=" in line
            )
    except FileNotFoundError:
        return "down"

    oper = state.get("OPER_STATE", "off")
    if oper == "routable":
        return "up"
    if oper in ("degraded", "carrier", "degraded-carrier"):
        return "limited"
    return "down"


def net_loop():
    with STATE_LOCK:
        STATE["net"] = check_net_status()
    emit()

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
    threading.Thread(target=cpu_ram_loop, daemon=True).start()
    threading.Thread(target=net_loop, daemon=True).start()
    threading.Event().wait()  # keep main thread alive


if __name__ == "__main__":
    main()
