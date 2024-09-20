#!/bin/sh
SXHKD_CONFIG="$HOME/.config/sxhkd/sxhkdrc"

awk '
	/^#/ {
		desc = substr($0, 3)
	}
	/^[[:alnum:]]/ {
		cmd = $0
		getline
		print cmd " : " desc
	}
' "$SXHKD_CONFIG" | rofi -dmenu -i -p "Keybindings"
