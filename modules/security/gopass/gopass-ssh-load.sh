#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# Load SSH keys from gopass password store
export GNUPGHOME="@@GNUPGHOME@@"
export GOPASS_SSH_KEYS="@@GOPASS_SSH_KEYS@@"

SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export SSH_AUTH_SOCK
if [ -z "$SSH_AUTH_SOCK" ] || [ ! -S "$SSH_AUTH_SOCK" ]; then
  echo "Error: SSH_AUTH_SOCK is not set or valid." >&2
  exit 1
fi

if ssh-add -l 2>/dev/null | grep -qE "(ED25519|RSA|ECDSA)"; then
  exit 0
fi

# GOPASS_SSH_KEYS holds a space-separated list of gopass entry names under ssh
if [ -z "${GOPASS_SSH_KEYS:-}" ]; then
  echo "Error: GOPASS_SSH_KEYS is not set. Example: GOPASS_SSH_KEYS=\"github gitlab\"" >&2
  exit 1
fi

# shellcheck disable=SC2086
read -r -a keys <<< "$GOPASS_SSH_KEYS"

for key in "${keys[@]}"; do
  if gopass cat "ssh/$key" > /dev/null 2>&1; then
    tmpdir=$(mktemp -d)
    keyfile="$tmpdir/key"
    gopass cat "ssh/$key" > "$keyfile" 2>/dev/null
    chmod 600 "$keyfile"

    passphrase=$(gopass cat "ssh/$key/passphrase" 2>/dev/null || true)
    if [ -n "$passphrase" ]; then
      ssh-keygen -p -P "$passphrase" -N "" -f "$keyfile" 2>/dev/null
    fi

    ssh-add "$keyfile" 2>/dev/null
    rm -rf "$tmpdir"
  else
    echo "Warning: no gopass entry ssh/$key" >&2
  fi
done
