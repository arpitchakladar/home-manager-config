# Path to your i3 config file
I3_CONFIG="$HOME/.config/i3/config"

# Function to wrap text
wrap_text() {
  local text="$1"
  local width="$2"
  echo "$text" | fold -s -w "$width"
}

# Get terminal width and calculate columns
terminal_width=$(tput cols)
table_width=$((terminal_width - 4))
max_keybinding_length=$((table_width / 3)) # Keybindings are usually shorter in i3
max_keybinding_content_length=$((max_keybinding_length - 2))
description_width=$((table_width - max_keybinding_length - 1))
description_content_width=$((description_width - 2))

# Border lines
top_border="┌$(printf '%.0s─' $(seq 1 $max_keybinding_length))┬$(printf '%.0s─' $(seq 1 $description_width))┐"
row_sep="├$(printf '%.0s─' $(seq 1 $max_keybinding_length))┼$(printf '%.0s─' $(seq 1 $description_width))┤"
bottom_border="└$(printf '%.0s─' $(seq 1 $max_keybinding_length))┴$(printf '%.0s─' $(seq 1 $description_width))┘"

{
  echo "$top_border"
  printf "│ %-*s │ %-*s │\n" "$max_keybinding_content_length" "KEYBINDING" "$description_content_width" "DESCRIPTION"
  
  last_comment=""

  # Read i3 config line by line
  while IFS= read -r line; do
    # If line is a comment, store it as a potential description
    if [[ $line =~ ^#\ (.*) ]]; then
      last_comment="${BASH_REMATCH[1]}"
    
    # If line contains a bindsym
    elif [[ $line =~ ^bindsym ]]; then
      # Extract the key combo (the parts between 'bindsym' and the start of the command/exec)
      # This regex captures bindsym [options] <keysym> <command>
      keybinding=$(echo "$line" | awk '{print $2}')
      
      # If the comment is empty, use the command itself as the description
      if [[ -z "$last_comment" ]]; then
          display_desc=$(echo "$line" | cut -d' ' -f3-)
      else
          display_desc="$last_comment"
      fi

      wrapped_description=$(wrap_text "$display_desc" "$description_content_width")

      echo "$row_sep"
      
      # Print first line of binding and description
      printf "│ %-*s │ %-*s │\n" "$max_keybinding_content_length" "$keybinding" "$description_content_width" "$(echo "$wrapped_description" | head -n 1)"

      # Print subsequent lines of wrapped description
      echo "$wrapped_description" | sed '1d' | while read -r continuation; do
        printf "│ %-*s │ %-*s │\n" "$max_keybinding_content_length" "" "$description_content_width" "$continuation"
      done

      # Reset comment after use
      last_comment=""
    fi
  done < "$I3_CONFIG"

  echo "$bottom_border"
} | less -R
