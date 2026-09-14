#!/usr/bin/env bash
# Load the SSH key stored in gopass into the gpg-agent.
#
# SSH keys are served by gpg-agent (enable-ssh-support): the private key at
# @@GOPASS_SSH_KEY@@ in the gopass store is added to the agent, so ssh works
# without ever needing a ~/.ssh directory. It runs automatically during every
# home-manager switch and exits early when the agent already holds an identity,
# so the gpg passphrase prompt only appears when it is actually needed.

set -o errexit
set -o nounset
set -o pipefail

export GNUPGHOME="@@GNUPGHOME@@"

GOPASS_SSH_KEY="@@GOPASS_SSH_KEY@@"

info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m==> warning:\033[0m %s\n' "$*" >&2; }
error() { printf '\033[1;31m==> error:\033[0m %s\n' "$*" >&2; }
die()   { error "$*"; exit 1; }

usage() {
  cat <<EOF
Usage: gpg-ssh-key-load [OPTS]

Loads the SSH key stored at "$GOPASS_SSH_KEY" in the gopass store into the
gpg-agent, so ssh uses the gpg-agent without creating a ~/.ssh directory.

Options:
  -h, --help    Show this help text
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help | -h)
      usage
      exit 0
      ;;
    *)
      error "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

# Make sure the agent is running and its ssh socket exists.
gpgconf --launch gpg-agent

SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export SSH_AUTH_SOCK
if [ -z "$SSH_AUTH_SOCK" ] || [ ! -S "$SSH_AUTH_SOCK" ]; then
  die "SSH_AUTH_SOCK is not set or valid."
fi

# Already holding an identity, nothing to do.
if ssh-add -l 2>/dev/null | grep -qE "(ED25519|RSA|ECDSA)"; then
  exit 0
fi

if ! gopass show -o "$GOPASS_SSH_KEY" > /dev/null 2>&1; then
  die "no gopass entry $GOPASS_SSH_KEY"
fi

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
keyfile="$tmpdir/key"
gopass show -o "$GOPASS_SSH_KEY" > "$keyfile" 2>/dev/null
chmod 600 "$keyfile"

passphrase=$(gopass show -o "$GOPASS_SSH_KEY/passphrase" 2>/dev/null || true)
if [ -n "$passphrase" ]; then
  ssh-keygen -p -P "$passphrase" -N "" -f "$keyfile" 2>/dev/null
fi

info "Loading SSH key ($GOPASS_SSH_KEY) into gpg-agent..."
if ! timeout 60 ssh-add "$keyfile"; then
  error "Failed to load SSH key into gpg-agent."
  error "Run \"ssh-add <(gopass show -o $GOPASS_SSH_KEY)\" manually."
  exit 1
fi

info "SSH key loaded into gpg-agent."