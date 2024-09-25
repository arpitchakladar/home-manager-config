#!/bin/sh
awk '
	/^#/ {
		desc = substr($0, 3)
	}
	/^[[:alnum:]]/ {
		cmd = $0
		getline
		print cmd " : " desc
	}
' "$HOME/.config/sxhkd/sxhkdrc" | rofi -dmenu -i -p "Keybindings"
