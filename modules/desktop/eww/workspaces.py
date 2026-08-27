#!/usr/bin/env python3
"""workspaces: emit workspace list with each workspace's focused-app icon,
driven by niri's event-stream instead of polling."""
import json
import subprocess
import gi
from gi.repository import Gio, Gtk
gi.require_version("Gtk", "3.0")

icon_theme = Gtk.IconTheme.get_default()
_icon_cache: dict[str, str] = {}


def try_desktop_app_info(desktop_id: str):
    try:
        return Gio.DesktopAppInfo.new(desktop_id)
    except TypeError:
        return None


def resolve_icon_path(app_id: str) -> str:
    if not app_id:
        return ""
    if app_id in _icon_cache:
        return _icon_cache[app_id]

    app_info = try_desktop_app_info(f"{app_id}.desktop") \
        or try_desktop_app_info(f"{app_id.lower()}.desktop")

    if app_info is None:
        for info in Gio.AppInfo.get_all():
            if isinstance(info, Gio.DesktopAppInfo):
                wm_class = info.get_startup_wm_class()
                if wm_class and wm_class.lower() == app_id.lower():
                    app_info = info
                    break

    icon_path = ""
    gicon = app_info.get_icon() if app_info else None
    if gicon is not None:
        lookup = icon_theme.lookup_by_gicon(gicon, 24, Gtk.IconLookupFlags.FORCE_SIZE)
        if lookup:
            icon_path = lookup.get_filename() or ""
    if not icon_path:
        lookup = icon_theme.lookup_icon(app_id, 24, Gtk.IconLookupFlags.FORCE_SIZE)
        if lookup:
            icon_path = lookup.get_filename() or ""

    _icon_cache[app_id] = icon_path
    return icon_path


def niri_json(*args):
    out = subprocess.run(["niri", "msg", "-j", *args], capture_output=True, text=True, check=True)
    return json.loads(out.stdout)


def emit_workspaces():
    workspaces = niri_json("workspaces")
    windows = {w["id"]: w for w in niri_json("windows")}

    def window_sort_key(w):
        # order windows as they appear in the columns; floating windows last
        pos = (w.get("layout") or {}).get("pos_in_scrolling_layout")
        if pos is not None:
            return (0, pos[0], pos[1])
        return (1, w["id"], 0)

    result = []
    for ws in sorted(workspaces, key=lambda w: w["idx"]):
        active_win = windows.get(ws.get("active_window_id"))
        app_id = (active_win or {}).get("app_id") or ""

        ws_name = ws.get("name") or f"Workspace {ws['idx']}"

        ws_windows = sorted(
            (w for w in windows.values() if w.get("workspace_id") == ws["id"]),
            key=window_sort_key,
        )
        lines = [ws_name] + [
            f"{i}. {(w.get('app_id') or 'unknown')}: {w.get('title') or '(untitled)'}"
            for i, w in enumerate(ws_windows, start=1)
        ]
        tooltip = "\n".join(lines) if ws_windows else ws_name

        result.append({
            "idx": ws["idx"],
            "id": ws["id"],
            "is_active": ws.get("is_active", False),
            "icon": resolve_icon_path(app_id),
            "tooltip": tooltip,
        })
    print(json.dumps(result), flush=True)


RELEVANT_EVENTS = {
    "WorkspacesChanged", "WorkspaceActivated", "WorkspaceUrgencyChanged",
    "WorkspaceActiveWindowChanged", "WindowOpenedOrChanged", "WindowClosed",
}


def main():
    emit_workspaces()
    proc = subprocess.Popen(
        ["niri", "msg", "-j", "event-stream"],
        stdout=subprocess.PIPE, text=True, bufsize=1,
    )
    for line in proc.stdout:
        try:
            key = next(iter(json.loads(line)))
        except (json.JSONDecodeError, StopIteration):
            continue
        if key in RELEVANT_EVENTS:
            try:
                emit_workspaces()
            except subprocess.CalledProcessError:
                pass


if __name__ == "__main__":
    main()
