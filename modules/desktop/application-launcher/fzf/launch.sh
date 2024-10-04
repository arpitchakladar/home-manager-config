#!/bin/sh

# Function to get executables from PATH and display them with Nerd Font icons
get_executables() {
	for dir in $(echo "$PATH" | tr ':' ' '); do
		[ -d "$dir" ] && ls "$dir" 2>/dev/null | awk -F/ '{print "\033[31m \033[0m " $NF}'
	done | sort -u
}

# Function to run fzf and select an executable
select_executable() {
	fzf --ansi --height=100% --border=none --layout=reverse --no-multi --prompt "  "
}

# Function to remove ANSI codes and icons from the selected executable
clean_selection() {
	sed 's/\x1B\[[0-9;]*m//g' | awk '{$1=""; print $0}' | sed 's/^ //'
}

# Main script execution
selected_executable=$(get_executables | select_executable | clean_selection)

# If an executable is selected, run it
if [ -n "$selected_executable" ]; then
	setsid "$selected_executable" >/dev/null 2>&1 &
	sleep 0.01
	kill -9 $PPID
fi
