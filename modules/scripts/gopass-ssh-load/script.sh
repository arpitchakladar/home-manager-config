export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

if [ -z "$SSH_AUTH_SOCK" ] || [ ! -S "$SSH_AUTH_SOCK" ]; then
  echo "Error: SSH_AUTH_SOCK is not set or valid." >&2
  exit 1
fi

if ssh-add -l 2>/dev/null | grep -qE "(ED25519|RSA|ECDSA)"; then
  exit 0
fi

for key in github gitlab bitbucket codeberg sourcehut; do
  if gopass cat "ssh/$key" > /dev/null 2>&1; then
    tmpdir=$(mktemp -d)
    keyfile="$tmpdir/key"
    gopass cat "ssh/$key" > "$keyfile" 2>/dev/null
    chmod 600 "$keyfile"

    if ! ssh-add "$keyfile" 2>/dev/null; then
      passphrase=$(gopass cat "ssh/$key/passphrase" 2>/dev/null)
      if [ -n "$passphrase" ]; then
        tmpcopy=$(mktemp)
        cp "$keyfile" "$tmpcopy"
        chmod 600 "$tmpcopy"
        if ssh-keygen -p -P "$passphrase" -N "" -f "$tmpcopy" 2>/dev/null; then
          ssh-add "$tmpcopy" 2>/dev/null
        fi
        rm -f "$tmpcopy"
      fi
    fi
    rm -rf "$tmpdir"
  fi
done
