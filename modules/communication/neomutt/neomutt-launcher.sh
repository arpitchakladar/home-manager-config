#!/usr/bin/env bash
# Wrapped neomutt: keeps the neomutt-sync systemd daemon alive for the
# lifetime of a neomutt session.
set -uo pipefail
SYSTEMCTL='@@SYSTEMCTL@@'
PGREP='@@PGREP@@'
NEOMUTT='@@NEOMUTT@@'

"$SYSTEMCTL" --user start neomutt-sync.service || true
stop_service() {
  "$PGREP" -x neomutt >/dev/null || "$SYSTEMCTL" --user stop neomutt-sync.service || true
}
trap stop_service EXIT

export PATH="@@PROFILE_BIN@@:@@URLSCAN_BIN@@:$PATH"
"$NEOMUTT" "$@"
