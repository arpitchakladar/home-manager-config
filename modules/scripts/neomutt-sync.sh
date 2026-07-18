# Neomutt-sync - Interactive mail sync with dialog progress bar
# 1. Create temporary files for the dark theme and notmuch logs
export DIALOGRC=$(mktemp)
NOTMUCH_LOG=$(mktemp)
TITLE="[SYNCING MAIL]"
BACK_TITLE=
trap 'rm -f "$DIALOGRC" "$NOTMUCH_LOG"' EXIT # Clean up everything on exit

cat << 'EOF' > "$DIALOGRC"
use_shadow = OFF
use_colors = ON
screen_color = (WHITE,BLACK,OFF)
dialog_color = (WHITE,BLACK,OFF)
title_color = (CYAN,BLACK,ON)
gauge_color = (WHITE,BLACK,ON)
border_color = (WHITE,BLACK,OFF)
border2_color = (WHITE,BLACK,OFF)
shadow_color = (BLACK,BLACK,OFF)

# Active buttons: Blue text and border with no background
button_active_color = (BLUE,BLACK,ON)
button_key_active_color = (BLUE,BLACK,ON)
button_label_active_color = (BLUE,BLACK,ON)

# Inactive buttons: Yellow text and border with no background
button_inactive_color = (YELLOW,BLACK,OFF)
button_key_inactive_color = (YELLOW,BLACK,OFF)
button_label_inactive_color = (YELLOW,BLACK,OFF)
EOF

# 2. Run the sync and indexing progress bar
(
  # --- PHASE 1: mbsync ---
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

  # --- PHASE 2: notmuch ---
  printf "XXX\n100\nIndexing new mail with notmuch...\nXXX\n"
  notmuch new > "$NOTMUCH_LOG" 2>&1
) | dialog --title "$TITLE" --gauge "Initializing..." 8 80 0

# 3. Format the captured notmuch output into a single clean line
CLEAN_OUT=$(tr '\n' ' ' < "$NOTMUCH_LOG" | sed 's/  */ /g')

# 4. Display final results and wait for user input (Enter/Esc) to dismiss
dialog --title "$TITLE" --msgbox "Done!\n$CLEAN_OUT" 8 80

clear
