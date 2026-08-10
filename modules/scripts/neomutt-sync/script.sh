DIALOGRC=$(mktemp)
NOTMUCH_LOG=$(mktemp)
TITLE="[󰇮  SYNCING MAIL]"
export DIALOGRC
trap 'rm -f "$DIALOGRC" "$NOTMUCH_LOG"' EXIT # Clean up everything on exit

cat << 'EOF' > "$DIALOGRC"
use_shadow = ON
use_colors = ON
screen_color = (WHITE,BLACK,OFF)
dialog_color = (WHITE,BLACK,ON)
title_color = (YELLOW,BLACK,ON)
gauge_color = (GREEN,BLACK,ON)
border_color = (CYAN,BLACK,ON)
border2_color = (BLUE,BLACK,ON)
shadow_color = (BLACK,BLACK,ON)

# Active buttons: magenta emphasis, matching Base16 base0E
button_active_color = (MAGENTA,BLACK,ON)
button_key_active_color = (MAGENTA,BLACK,ON)
button_label_active_color = (MAGENTA,BLACK,ON)

# Inactive buttons: cyan secondary emphasis, matching Base16 base0C
button_inactive_color = (CYAN,BLACK,OFF)
button_key_inactive_color = (CYAN,BLACK,OFF)
button_label_inactive_color = (CYAN,BLACK,OFF)
EOF

# Run the sync and indexing progress bar
(
  # mbsync phase
  script -q -e -c "mbsync -a" /dev/null | awk -v RS='\r' '
  {
    c_str = ""
    b_str = ""
    for(i=1; i<=NF; i++) {
      if ($i == "C:") c_str = $(i+1)
      if ($i == "B:") b_str = $(i+1)
    }
    if (b_str != "") {
      split(b_str, arr, "/")
      if (arr[2] > 0) {
        percent = int((arr[1] / arr[2]) * 100)
        printf "XXX\n%d\nSyncing | Channel: %s   |   Mailbox: %s\nXXX\n", percent, c_str, b_str
      }
    }
    fflush()
  }'

  # notmuch phase
  printf "XXX\n100\nIndexing new mail with notmuch...\nXXX\n"
  notmuch new > "$NOTMUCH_LOG" 2>&1
) | dialog --title "$TITLE" --gauge "Initializing..." 8 80 0

# Format the captured notmuch output into a single clean line
CLEAN_OUT=$(tr '\n' ' ' < "$NOTMUCH_LOG" | sed 's/  */ /g')

# Display final results and wait for user input
dialog --title "$TITLE" --msgbox "Done!\n$CLEAN_OUT" 8 80

clear
