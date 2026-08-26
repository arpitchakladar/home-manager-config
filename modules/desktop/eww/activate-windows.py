#!/usr/bin/env python3
"""active-windows: emit icons for windows on the currently active
niri workspace, driven by niri's event-stream instead of polling."""
import json
import subprocess
import gi
from gi.repository import Gio, Gtk

gi.require_version("Gtk", "3.0")

icon_theme = Gtk.IconTheme.get_default()
_icon_cache: dict[str, str] = {}


def resolve_icon_path(app_id: str) -> str:
    if not app_id:
        return ""
    if app_id in _icon_cache:
        return _icon_cache[app_id]

    app_info = Gio.DesktopAppInfo.new(f"{app_id}.desktop") \
        or Gio.DesktopAppInfo.new(f"{app_id.lower()}.desktop")

    # fall back: scan installed .desktop files for a matching StartupWMClass
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
        lookup = icon_theme.lookup_by_gicon(gicon,
                                            32,
                                            Gtk.IconLookupFlags.FORCE_SIZE)
        if lookup:
            icon_path = lookup.get_filename() or ""

    if not icon_path:
        # last resort: treat app_id itself as an icon-theme name
        lookup = icon_theme.lookup_icon(app_id,
                                        32,
                                        Gtk.IconLookupFlags.FORCE_SIZE)
        if lookup:
            icon_path = lookup.get_filename() or ""

    _icon_cache[app_id] = icon_path
    return icon_path


def niri_json(*args):
    out = subprocess.run(["niri", "msg", "-j", *args],
                         capture_output=True,
                         text=True,
                         check=True)
    return json.loads(out.stdout)


def emit_active_windows():
    workspaces = niri_json("workspaces")
    windows = niri_json("windows")

    active_ws = next((w for w in workspaces if w.get("is_active")), None)
    active_id = active_ws["id"] if active_ws else None

    result = [
        {
            "id": w["id"],
            "title": w.get("title", ""),
            "app_id": w.get("app_id") or "",
            "is_focused": w.get("is_focused", False),
            "icon": resolve_icon_path(w.get("app_id") or ""),
        }
        for w in windows
        if w.get("workspace_id") == active_id
    ]
    print(json.dumps(result), flush=True)


RELEVANT_EVENTS = {
    "WindowOpenedOrChanged", "WindowClosed", "WindowFocusChanged",
    "WorkspaceActivated", "WorkspacesChanged", "WindowsChanged",
}


def main():
    emit_active_windows()
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
                emit_active_windows()
            except subprocess.CalledProcessError:
                pass


if __name__ == "__main__":
    main()
