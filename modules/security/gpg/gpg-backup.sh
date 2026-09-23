#!/usr/bin/env bash
# Export all GPG keys and revocation certificates to an encrypted backup
# file, or decrypt and import them back from one.

set -euo pipefail

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m==> warning:\033[0m %s\n' "$*" >&2; }
error() { printf '\033[1;31m==> error:\033[0m %s\n' "$*" >&2; }
die() {
  error "$*"
  exit 1
}

WORKDIR="$(mktemp -d)"

cleanup() {
  if [[ -d $WORKDIR ]]; then
    find "$WORKDIR" -type f -exec shred -u -z {} \; 2>/dev/null || true
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

usage() {
  echo "Usage: $0 <export|import> <filename>"
  echo ""
  echo "Commands:"
  echo "  export    Export all GPG keys to an encrypted file"
  echo "  import    Decrypt and import keys from a backup file"
  exit 1
}

do_export() {
  local outfile="$1"

  if [[ -e $outfile ]]; then
    die "Refusing to overwrite existing file: $outfile"
  fi

  info "Exporting public keys..."
  gpg --export --armor >"$WORKDIR/public-keys.asc"

  info "Exporting secret keys..."
  gpg --export-secret-keys --armor >"$WORKDIR/secret-keys.asc"

  info "Exporting secret subkeys (if any)..."
  gpg --export-secret-subkeys --armor >"$WORKDIR/secret-subkeys.asc" || true

  info "Exporting owner trust database..."
  gpg --export-ownertrust >"$WORKDIR/ownertrust.txt"

  info "Exporting revocation certificates..."
  mkdir -p "$WORKDIR/revocation-certs"
  if [[ -d "$HOME/.gnupg/openpgp-revocs.d" ]]; then
    cp "$HOME"/.gnupg/openpgp-revocs.d/*.rev "$WORKDIR/revocation-certs/" 2>/dev/null || true
  fi

  info "Bundling everything into a single archive..."
  tar -C "$WORKDIR" -cf "$WORKDIR/gpg-full-backup.tar" \
    public-keys.asc \
    secret-keys.asc \
    secret-subkeys.asc \
    ownertrust.txt \
    revocation-certs

  info "Encrypting with GPG (AES256, SHA512, max S2K iteration count)..."
  echo "  You will be prompted for a passphrase — use a strong one."
  gpg --symmetric \
    --cipher-algo AES256 \
    --digest-algo SHA512 \
    --s2k-mode 3 \
    --s2k-digest-algo SHA512 \
    --s2k-count 65011712 \
    --output "$outfile" \
    "$WORKDIR/gpg-full-backup.tar"

  info "Verifying: attempting decryption to confirm it works..."
  if gpg --decrypt "$outfile" >"$WORKDIR/verify.tar" 2>/dev/null; then
    if cmp -s "$WORKDIR/gpg-full-backup.tar" "$WORKDIR/verify.tar"; then
      info "Verification succeeded: backup decrypts correctly."
    else
      die "Decrypted content does not match original. Investigate before trusting this backup."
    fi
  else
    die "Decryption test failed."
  fi

  echo
  info "Done."
  echo "  Encrypted backup: $outfile"
  echo "  Store this file somewhere safe (offline media, encrypted drive)."
  echo "  The S2K iteration count only helps if your passphrase itself"
  echo "  has real entropy (e.g. a long diceware passphrase)."
}

do_import() {
  local infile="$1"

  if [[ ! -f $infile ]]; then
    die "File not found: $infile"
  fi

  info "Decrypting $infile ..."
  echo "  You will be prompted for the backup's passphrase."
  echo "  Note: this may take a while due to the high S2K iteration count."
  gpg --decrypt "$infile" >"$WORKDIR/gpg-full-backup.tar"

  info "Extracting archive..."
  tar -C "$WORKDIR" -xf "$WORKDIR/gpg-full-backup.tar"

  info "Importing public keys..."
  gpg --import "$WORKDIR/public-keys.asc"

  info "Importing secret keys..."
  gpg --import "$WORKDIR/secret-keys.asc"

  if [[ -s "$WORKDIR/secret-subkeys.asc" ]]; then
    info "Importing secret subkeys..."
    gpg --import "$WORKDIR/secret-subkeys.asc" || true
  fi

  if [[ -f "$WORKDIR/ownertrust.txt" ]]; then
    info "Importing owner trust database..."
    gpg --import-ownertrust "$WORKDIR/ownertrust.txt"
  fi

  if [[ -d "$WORKDIR/revocation-certs" ]] && [[ -n "$(ls -A "$WORKDIR/revocation-certs" 2>/dev/null)" ]]; then
    info "Restoring revocation certificates..."
    mkdir -p "$HOME/.gnupg/openpgp-revocs.d"
    cp "$WORKDIR"/revocation-certs/*.rev "$HOME/.gnupg/openpgp-revocs.d/" 2>/dev/null || true
  fi

  echo
  info "Done. Keys imported into your GPG keyring."
  echo "  Run 'gpg --list-secret-keys' to confirm."
}

# Main

if [[ $# -ne 2 ]]; then
  usage
fi

command="$1"
filename="$2"

case "$command" in
export)
  do_export "$filename"
  ;;
import)
  do_import "$filename"
  ;;
*)
  usage
  ;;
esac
