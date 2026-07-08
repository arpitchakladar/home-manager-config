#!/usr/bin/env bash
set -euo pipefail

target="${1:--a}"
mail_root="${XDG_DATA_HOME:-$HOME/.local/share}/mail"
mkdir -p "$mail_root"

if [[ "$target" == "all" ]]; then
  target="-a"
else
  mkdir -p "${mail_root}/${target}/INBOX/cur" "${mail_root}/${target}/INBOX/new" "${mail_root}/${target}/INBOX/tmp"
fi

mbsync "$target"
notmuch new
