#!/usr/bin/env bash
# Starts the neomutt-sync daemon before starting neomutt
set -uo pipefail

systemctl --user start neomutt-sync.service || true

"@@NEOMUTT_BIN@@" "$@"
