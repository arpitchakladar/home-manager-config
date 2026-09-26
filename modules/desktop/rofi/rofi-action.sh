#!/usr/bin/env bash
# Fire-and-forget action menu driven by rofi's dmenu mode.
# The entries and the commands they run are generated at build time
# from `config.desktop.rofi.action.actions`.

options="@@OPTIONS@@"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Action:")

case "$chosen" in
"@@CASES@@") : ;;
esac
