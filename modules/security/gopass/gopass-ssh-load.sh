#!/usr/bin/env bash

# gopass-ssh-load
#
# Load SSH keys into the SSH agent from the gopass password store.
#
# This script reads private keys and (optionally) their passphrases from gopass
# entries under the `ssh/` directory and adds them to the SSH agent served by
# gpg-agent. It is meant to be run manually whenever a key is imported into or
# rotated within the gopass store, so the SSH agent picks up the change.
#
# Behaviour:
#   * It first verifies that a usable SSH agent socket exists and bails out if
#     not.
#   * It exits early (without doing anything) when the agent already has at
#     least one Ed25519/RSA/ECDSA identity loaded, to avoid useless work and
#     unnecessary gpg passphrase prompts.
#   * For each key listed in GOPASS_SSH_KEYS it writes the corresponding
#     `ssh/<key>` entry to a temporary file, strips the passphrase using the
#     `ssh/<key>/passphrase` entry, and registers the key with `ssh-add`.
#
# Temporary key files are written with mode 600 and removed afterwards.

set -o errexit
set -o nounset
set -o pipefail

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
