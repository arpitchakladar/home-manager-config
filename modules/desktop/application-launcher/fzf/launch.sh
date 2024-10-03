#!/bin/sh

selected_executable=$(for dir in $(echo "$PATH" | tr ':' ' '); do [ -d "$dir" ] && ls "$dir" 2>/dev/null | awk -F/ '{print $NF}'; done | sort -u | fzf --height=100% --border=none --layout=reverse --prompt "  ")

if [[ -n "$selected_executable" ]]; then
	setsid "$selected_executable" >/dev/null 2>&1 &
	disown
	sleep
	kill -9 $PPID
fi
