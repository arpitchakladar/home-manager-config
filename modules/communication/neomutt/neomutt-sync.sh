#!/usr/bin/env bash
# Sync one mbsync channel and index new messages with notmuch.

set -uo pipefail

MBSYNCRC="${MBSYNCRC:-$HOME/.config/mbsync/.mbsyncrc}"
TITLE="[󰇮  SYNCING MAIL]"

DIALOGRC=$(mktemp)
MBSYNC_LOG=$(mktemp)
NOTMUCH_LOG=$(mktemp)

export DIALOGRC

trap 'rm -f "$DIALOGRC" "$MBSYNC_LOG" "$NOTMUCH_LOG"' EXIT

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <mbsync-channel>"
  echo
  echo "Example:"
  echo "  $0 arpitchakladar-gmail_com-quick"
  echo "  $0 arpitchakladar-gmail_com-full"
  exit 2
fi

CHANNEL="$1"

cat <<'EOF' > "$DIALOGRC"
use_shadow = ON
use_colors = ON
screen_color = (WHITE,BLACK,OFF)
dialog_color = (WHITE,BLACK,ON)
title_color = (YELLOW,BLACK,ON)
gauge_color = (GREEN,BLACK,ON)
border_color = (CYAN,BLACK,ON)
border2_color = (BLUE,BLACK,ON)
shadow_color = (BLACK,BLACK,ON)

button_active_color = (MAGENTA,BLACK,ON)
button_key_active_color = (MAGENTA,BLACK,ON)
button_label_active_color = (MAGENTA,BLACK,ON)

button_inactive_color = (CYAN,BLACK,OFF)
button_key_inactive_color = (CYAN,BLACK,OFF)
button_label_inactive_color = (CYAN,BLACK,OFF)
EOF

(
  printf "XXX\n0\nSyncing: %s...\nXXX\n" "$CHANNEL"

  mbsync -c "$MBSYNCRC" "$CHANNEL" > "$MBSYNC_LOG" 2>&1 &
  PID=$!

  # Keep the gauge alive while mbsync runs.
  while kill -0 "$PID" 2>/dev/null; do
    printf "XXX\n50\nSyncing: %s...\nXXX\n" "$CHANNEL"
    sleep 0.5
  done

  wait "$PID"
  MBSYNC_STATUS=$?

  if (( MBSYNC_STATUS != 0 )); then
    printf "XXX\n100\nSync failed: %s\nXXX\n" "$CHANNEL"
    exit "$MBSYNC_STATUS"
  fi

  printf "XXX\n90\nIndexing new mail with notmuch...\nXXX\n"

  notmuch new --quiet > "$NOTMUCH_LOG" 2>&1
  NOTMUCH_STATUS=$?

  printf "XXX\n100\nDone.\nXXX\n"

  if (( NOTMUCH_STATUS != 0 )); then
    exit "$NOTMUCH_STATUS"
  fi
) | dialog --title "$TITLE" --gauge "Initializing..." 8 80 0

STATUS=${PIPESTATUS[0]}

MBSYNC_OUT=$(
  tr '\n' ' ' < "$MBSYNC_LOG" |
  sed 's/  */ /g'
)

NOTMUCH_OUT=$(
  tr '\n' ' ' < "$NOTMUCH_LOG" |
  sed 's/  */ /g'
)

if (( STATUS == 0 )); then
  dialog \
    --title "$TITLE" \
    --msgbox "Done!\n\nChannel: $CHANNEL\n\nmbsync: ${MBSYNC_OUT:-OK}\n\nnotmuch: ${NOTMUCH_OUT:-OK}" \
    12 80
else
  dialog \
    --title "$TITLE" \
    --msgbox "Sync failed!\n\nChannel: $CHANNEL\n\nmbsync: ${MBSYNC_OUT:-no output}\n\nnotmuch: ${NOTMUCH_OUT:-not run}" \
    12 80
fi

clear
exit "$STATUS"
