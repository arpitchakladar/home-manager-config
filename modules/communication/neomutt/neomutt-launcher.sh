#!/usr/bin/env bash
# Wrapped neomutt: keeps the neomutt-sync systemd daemon alive for the
# lifetime of a neomutt session.
set -uo pipefail

systemctl --user start neomutt-sync.service || true
stop_service() {
  pgrep -x neomutt >/dev/null || systemctl --user stop neomutt-sync.service || true
}
trap stop_service EXIT

export PATH="@@PROFILE_BIN@@:$PATH"
neomutt "$@"
