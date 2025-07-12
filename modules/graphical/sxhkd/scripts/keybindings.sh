#!/bin/sh

# Path to your sxhkd config file
SXHKD_FILE="$HOME/.config/sxhkd/sxhkdrc"

# Function to wrap text to a specified width
wrap_text() {
	local text="$1"
	local width="$2"
	echo "$text" | fold -s -w "$width"
}

# Get terminal width
terminal_width=$(tput cols)

# Set the table width to the full terminal width, leaving space for borders
table_width=$((terminal_width - 4))  # 4 for the borders and space between columns

# Set keybinding column width to half of the available width
max_keybinding_length=$((table_width / 2))

# Length of the cotent inside the cell (2 spaces are substracted for padding)
max_keybinding_content_length=$((max_keybinding_length - 2))

# Set the description column width to the other half
description_width=$((table_width - max_keybinding_length - 1))  # 1 for the separator between columns

# Length of the cotent inside the cell (2 spaces are substracted for padding)
description_content_width=$((description_width - 2))

# Generate the top border line and row separator
border_line="├$(printf '%.0s─' $(seq 1 $max_keybinding_length))┼$(printf '%.0s─' $(seq 1 $description_width))┤"

# Pipe all output to less
{
	# Print table header with borders
	echo "┌$(printf '%.0s─' $(seq 1 $max_keybinding_length))┬$(printf '%.0s─' $(seq 1 $description_width))┐"
	printf "│ %-*s │ %-*s │\n" "$max_keybinding_content_length" "KEYBINDING" "$description_content_width" "DESCRIPTION"

	# Initialize variables
	description=""

	# Load the sxhkd file into an array
	mapfile -t lines < "$SXHKD_FILE"

	# Loop through lines for output
	for line in "${lines[@]}"; do
		# Check if the line is a comment
		if [[ $line =~ ^# ]]; then
			# Remove the "#" and any leading/trailing whitespace to capture the description
			description="${line#\# }"
		elif [[ $line =~ ^[^#[:space:]] ]]; then
			# If it's a keybinding line, store it
			keybinding="$line"
			# Move to the next line for the command
			command="${lines[((++i))]}"

			# Wrap the description to the calculated width
			wrapped_description=$(wrap_text "$description" "$description_width")

			# Print the keybinding with a border line above and below it
			echo "$border_line"
			printf "│ %-*s │ %-*s │\n" "$max_keybinding_content_length" "$keybinding" "$description_content_width" "$(echo "$wrapped_description" | head -n 1)"
			
			# Print wrapped description lines with empty keybinding column
			echo "$wrapped_description" | sed '1d' | while read -r continuation; do
				printf "│ %-*s │ %-*s │\n" "$max_keybinding_content_length" "" "$description_content_width" "$continuation"
			done

			# Reset description for the next keybinding
			description=""
		fi
	done

	# Print the final border line
	echo "└$(printf '%.0s─' $(seq 1 $max_keybinding_length))┴$(printf '%.0s─' $(seq 1 $description_width))┘"
} | less
