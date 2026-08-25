#!/usr/bin/env bash
set -euo pipefail
niri msg -j workspaces | jq -c 'sort_by(.idx)'
