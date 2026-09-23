#!/usr/bin/env bash
# systemd daemon: full-sync the -full channels every 10 minutes while
# neomutt is open. Started/stopped by the wrapped neomutt launcher.

set -uo pipefail

INTERVAL="$((10 * 60))"
MBSYNCRC="${MBSYNCRC:-$HOME/.config/mbsync/.mbsyncrc}"

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <mbsync-channel> [channel...]" >&2
  exit 2
fi

sync_once() {
  echo "Syncing: $*"

  mbsync -c "$MBSYNCRC" "$@"
  local status=$?
  if ((status != 0)); then
    echo "mbsync failed (status $status) for: $*" >&2
    return "$status"
  fi

  echo "Indexing new mail with notmuch..."
  notmuch new --quiet
}

while true; do
  sync_once "$@"
  sleep "$INTERVAL"

  # Safety net: the launcher stops this service when neomutt exits; if that
  # didn't happen (hard kill), bail out once neomutt is gone.
  if ! pgrep -x neomutt >/dev/null; then
    echo "neomutt is not running; stopping sync daemon" >&2
    exit 0
  fi
done
