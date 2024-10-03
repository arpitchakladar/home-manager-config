#!/bin/sh

selected_executable=$(find -L $(echo $PATH | tr ':' ' ') -maxdepth 1 -executable -type f 2>/dev/null | xargs -n 1 basename | sort -u | fzf --height=100% --layout=reverse --prompt "  ")

if [[ -n "$selected_executable" ]]; then
	setsid "$selected_executable" >/dev/null 2>&1 &
	disown
	sleep
	kill -9 $PPID
fi
