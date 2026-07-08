#!/usr/bin/env bash
set -euo pipefail

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
state_home="${XDG_STATE_HOME:-$HOME/.local/state}"
password_store_dir="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

mail_root="${data_home}/mail"
isync_config="${config_home}/isyncrc"
aerc_accounts="${config_home}/aerc/accounts.conf"
notmuch_config="${config_home}/notmuch/default/config"
query_map="${config_home}/aerc/notmuch-query-map"

usage() {
  cat <<'USAGE'
Usage:
  aerc-mail-setup add      Add or update a Gmail, Yahoo, or Outlook account
  aerc-mail-setup remove   Remove generated aerc/isync blocks for an account
  aerc-mail-setup list     List generated accounts
  aerc-mail-setup sync     Run mbsync and notmuch indexing

Secrets are stored through pass(1). Generated private config is written under
~/.config/isyncrc, ~/.config/aerc/accounts.conf, and ~/.config/notmuch/default/config.
Removing an account only removes generated config blocks; it does not delete mail or passwords.
USAGE
}

prompt() {
  local label="$1"
  local default="${2:-}"
  local value

  if [[ -n "$default" ]]; then
    printf '%s [%s]: ' "$label" "$default" >&2
    read -r value
    printf '%s\n' "${value:-$default}"
  else
    printf '%s: ' "$label" >&2
    read -r value
    printf '%s\n' "$value"
  fi
}

sanitize_account() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_.-]/-/g'
}

url_encode_user() {
  printf '%s' "$1" | sed 's/%/%25/g; s/@/%40/g; s/+/%2B/g'
}

ensure_query_map() {
  mkdir -p "$(dirname "$query_map")"
  if [[ ! -e "$query_map" ]]; then
    cat >"$query_map" <<'EOF'
Inbox=tag:inbox and not tag:deleted
Unread=tag:unread and not tag:deleted
Flagged=tag:flagged and not tag:deleted
Sent=folder:sent or folder:Sent or folder:"[Gmail]/Sent Mail"
Archive=not tag:inbox and not tag:deleted
All=*
EOF
  fi
}

write_notmuch_config() {
  local name="$1"
  local email="$2"

  mkdir -p "$(dirname "$notmuch_config")" "$mail_root" "$state_home/isync"
  if [[ ! -e "$notmuch_config" ]]; then
    cat >"$notmuch_config" <<EOF
[database]
path=${mail_root}
mail_root=${mail_root}

[user]
name=${name}
primary_email=${email}

[new]
tags=unread;inbox;
ignore=.uidvalidity;.mbsyncstate

[search]
exclude_tags=deleted;spam;

[maildir]
synchronize_flags=true
EOF
  fi
}

replace_block() {
  local file="$1"
  local block_name="$2"
  local tmp

  mkdir -p "$(dirname "$file")"
  tmp="$(mktemp)"
  if [[ -e "$file" ]]; then
    awk -v start="# BEGIN ${block_name}" -v end="# END ${block_name}" '
      $0 == start { skip = 1; next }
      $0 == end { skip = 0; next }
      !skip { print }
    ' "$file" >"$tmp"
  fi

  {
    sed '/^[[:space:]]*$/N;/^\n$/D' "$tmp" 2>/dev/null || true
    printf '\n# BEGIN %s\n' "$block_name"
    cat
    printf '# END %s\n' "$block_name"
  } >"$file"
  rm -f "$tmp"
  chmod 600 "$file"
}

remove_block() {
  local file="$1"
  local block_name="$2"
  local tmp

  [[ -e "$file" ]] || return
  tmp="$(mktemp)"
  awk -v start="# BEGIN ${block_name}" -v end="# END ${block_name}" '
    $0 == start { skip = 1; next }
    $0 == end { skip = 0; next }
    !skip { print }
  ' "$file" >"$tmp"
  cat "$tmp" >"$file"
  rm -f "$tmp"
  chmod 600 "$file"
}

pass_insert_if_requested() {
  local pass_entry="$1"

  if pass show "$pass_entry" >/dev/null 2>&1; then
    return
  fi

  printf 'No pass entry found at %s.\n' "$pass_entry"
  if [[ ! -f "${password_store_dir}/.gpg-id" ]]; then
    cat >&2 <<EOF
pass is not initialized yet.

Create or choose a GPG key, then initialize pass with:
  gpg --list-secret-keys --keyid-format=long
  pass init <gpg-key-id-or-email>

After that, rerun:
  aerc-mail-setup add
EOF
    exit 1
  fi

  printf 'Store the password there now? [y/N]: '
  read -r answer
  case "$answer" in
    y|Y|yes|YES)
      pass insert "$pass_entry"
      ;;
    *)
      printf 'Create it later with: pass insert %s\n' "$pass_entry"
      ;;
  esac
}

provider_defaults() {
  local provider="$1"
  case "$provider" in
    gmail)
      imap_host="imap.gmail.com"
      imap_port="993"
      imap_tls="IMAPS"
      imap_auth="LOGIN"
      smtp_host="smtp.gmail.com"
      smtp_port="587"
      smtp_scheme="smtp+login"
      ;;
    yahoo)
      imap_host="imap.mail.yahoo.com"
      imap_port="993"
      imap_tls="IMAPS"
      imap_auth="LOGIN"
      smtp_host="smtp.mail.yahoo.com"
      smtp_port="587"
      smtp_scheme="smtp+login"
      ;;
    outlook)
      imap_host="outlook.office365.com"
      imap_port="993"
      imap_tls="IMAPS"
      imap_auth="LOGIN"
      smtp_host="smtp.office365.com"
      smtp_port="587"
      smtp_scheme="smtp+login"
      ;;
    *)
      printf 'Unsupported provider: %s\n' "$provider" >&2
      exit 1
      ;;
  esac
}

add_account() {
  local provider account email name user pass_entry sync_patterns
  local imap_host imap_port imap_tls imap_auth smtp_host smtp_port smtp_scheme
  local encoded_user

  provider="$(prompt "Provider (gmail/yahoo/outlook)")"
  provider="$(printf '%s' "$provider" | tr '[:upper:]' '[:lower:]')"
  provider_defaults "$provider"
  sync_patterns="*"

  email="$(prompt "Email address")"
  account="$(prompt "Account id" "$(sanitize_account "$email")")"
  account="$(sanitize_account "$account")"
  name="$(prompt "Display name")"

  printf 'Use an app password stored in pass; OAuth is not configured here.\n'
  user="$(prompt "IMAP/SMTP username" "$email")"

  imap_host="$(prompt "IMAP host" "$imap_host")"
  imap_port="$(prompt "IMAP port" "$imap_port")"
  imap_tls="$(prompt "mbsync IMAP TLS mode (IMAPS/STARTTLS/None)" "$imap_tls")"
  imap_auth="$(prompt "mbsync IMAP auth mechanism" "$imap_auth")"
  smtp_host="$(prompt "SMTP host" "$smtp_host")"
  smtp_port="$(prompt "SMTP port" "$smtp_port")"
  smtp_scheme="$(prompt "aerc SMTP scheme" "$smtp_scheme")"

  pass_entry="$(prompt "pass entry for this account password" "mail/${account}")"
  pass_insert_if_requested "$pass_entry"

  mkdir -p "${mail_root}/${account}/INBOX/cur" "${mail_root}/${account}/INBOX/new" "${mail_root}/${account}/INBOX/tmp"
  ensure_query_map
  write_notmuch_config "$name" "$email"

  replace_block "$isync_config" "aerc-mail:${account}" <<EOF
IMAPAccount ${account}-remote
Host ${imap_host}
Port ${imap_port}
User ${user}
PassCmd "pass show ${pass_entry}"
TLSType ${imap_tls}
AuthMechs ${imap_auth}

IMAPStore ${account}-remote
Account ${account}-remote

MaildirStore ${account}-local
SubFolders Verbatim
Path ${mail_root}/${account}/
Inbox ${mail_root}/${account}/INBOX

Channel ${account}
Far :${account}-remote:
Near :${account}-local:
Patterns ${sync_patterns}
Create Both
Remove Both
Expunge Both
Sync Full
SyncState *
EOF

  encoded_user="$(url_encode_user "$user")"
  replace_block "$aerc_accounts" "aerc-mail:${account}" <<EOF
[${account}]
source = notmuch://${mail_root}
maildir-store = ${mail_root}
maildir-account-path = ${account}
multi-file-strategy = act-all
query-map = ${query_map}
from = ${name} <${email}>
outgoing = ${smtp_scheme}://${encoded_user}@${smtp_host}:${smtp_port}
outgoing-cred-cmd = pass show ${pass_entry}
check-mail = 5m
check-mail-cmd = aerc-sync-mail ${account}
check-mail-timeout = 5m
default = Inbox
copy-to = Sent
archive = Archive
postpone = Drafts
EOF

  printf 'Configured %s. Run this once for the initial download:\n' "$account"
  printf '  aerc-sync-mail %s\n' "$account"
}

list_accounts() {
  if [[ ! -e "$aerc_accounts" ]]; then
    printf 'No generated accounts found.\n'
    return
  fi
  sed -n 's/^# BEGIN aerc-mail:\(.*\)$/\1/p' "$aerc_accounts"
}

remove_account() {
  local account

  account="$(prompt "Account id to remove")"
  account="$(sanitize_account "$account")"

  remove_block "$isync_config" "aerc-mail:${account}"
  remove_block "$aerc_accounts" "aerc-mail:${account}"
  printf 'Removed generated config blocks for %s.\n' "$account"
}

case "${1:-}" in
  add)
    add_account
    ;;
  remove)
    remove_account
    ;;
  list)
    list_accounts
    ;;
  sync)
    shift
    aerc-sync-mail "$@"
    ;;
  -h|--help|help|"")
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
