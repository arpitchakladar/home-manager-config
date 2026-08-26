#!/usr/bin/env bash
set -euo pipefail

print_workspaces() {
  niri msg -j workspaces | jq -c --unbuffered 'sort_by(.idx)'
}

print_workspaces

niri msg -j event-stream | while IFS= read -r line; do
  case "$line" in
    *WorkspacesChanged*|*WorkspaceActivated*|*WorkspaceUrgencyChanged*|*WorkspaceActiveWindowChanged*)
      print_workspaces
      ;;
  esac
done
