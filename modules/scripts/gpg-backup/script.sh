set -euo pipefail

WORKDIR="$(mktemp -d)"

cleanup() {
  if [[ -d "$WORKDIR" ]]; then
    find "$WORKDIR" -type f -exec shred -u -z {} \; 2>/dev/null || true
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

usage() {
  echo "Usage:"
  echo "  $0 export <filename>   Export all GPG keys to an encrypted file"
  echo "  $0 import <filename>   Decrypt and import keys from a backup file"
  exit 1
}

do_export() {
  local outfile="$1"

  if [[ -e "$outfile" ]]; then
    echo "!! Refusing to overwrite existing file: $outfile" >&2
    exit 1
  fi

  echo "==> Exporting public keys..."
  gpg --export --armor > "$WORKDIR/public-keys.asc"

  echo "==> Exporting secret keys..."
  gpg --export-secret-keys --armor > "$WORKDIR/secret-keys.asc"

  echo "==> Exporting secret subkeys (if any)..."
  gpg --export-secret-subkeys --armor > "$WORKDIR/secret-subkeys.asc" || true

  echo "==> Exporting owner trust database..."
  gpg --export-ownertrust > "$WORKDIR/ownertrust.txt"

  echo "==> Exporting revocation certificates..."
  mkdir -p "$WORKDIR/revocation-certs"
  if [[ -d "$HOME/.gnupg/openpgp-revocs.d" ]]; then
    cp "$HOME"/.gnupg/openpgp-revocs.d/*.rev "$WORKDIR/revocation-certs/" 2>/dev/null || true
  fi

  echo "==> Bundling everything into a single archive..."
  tar -C "$WORKDIR" -cf "$WORKDIR/gpg-full-backup.tar" \
    public-keys.asc \
    secret-keys.asc \
    secret-subkeys.asc \
    ownertrust.txt \
    revocation-certs

  echo "==> Encrypting with GPG (AES256, SHA512, max S2K iteration count)..."
  echo "  You will be prompted for a passphrase — use a strong one."
  gpg --symmetric \
    --cipher-algo AES256 \
    --digest-algo SHA512 \
    --s2k-mode 3 \
    --s2k-digest-algo SHA512 \
    --s2k-count 65011712 \
    --output "$outfile" \
    "$WORKDIR/gpg-full-backup.tar"

  echo "==> Verifying: attempting decryption to confirm it works..."
  if gpg --decrypt "$outfile" > "$WORKDIR/verify.tar" 2>/dev/null; then
    if cmp -s "$WORKDIR/gpg-full-backup.tar" "$WORKDIR/verify.tar"; then
      echo "==> Verification succeeded: backup decrypts correctly."
    else
      echo "!! WARNING: decrypted content does not match original. Investigate before trusting this backup." >&2
      exit 1
    fi
  else
    echo "!! WARNING: decryption test failed." >&2
    exit 1
  fi

  echo
  echo "==> Done."
  echo "  Encrypted backup: $outfile"
  echo "  Store this file somewhere safe (offline media, encrypted drive)."
  echo "  The S2K iteration count only helps if your passphrase itself"
  echo "  has real entropy (e.g. a long diceware passphrase)."
}

do_import() {
  local infile="$1"

  if [[ ! -f "$infile" ]]; then
    echo "!! File not found: $infile" >&2
    exit 1
  fi

  echo "==> Decrypting $infile ..."
  echo "  You will be prompted for the backup's passphrase."
  echo "  Note: this may take a while due to the high S2K iteration count."
  gpg --decrypt "$infile" > "$WORKDIR/gpg-full-backup.tar"

  echo "==> Extracting archive..."
  tar -C "$WORKDIR" -xf "$WORKDIR/gpg-full-backup.tar"

  echo "==> Importing public keys..."
  gpg --import "$WORKDIR/public-keys.asc"

  echo "==> Importing secret keys..."
  gpg --import "$WORKDIR/secret-keys.asc"

  if [[ -s "$WORKDIR/secret-subkeys.asc" ]]; then
    echo "==> Importing secret subkeys..."
    gpg --import "$WORKDIR/secret-subkeys.asc" || true
  fi

  if [[ -f "$WORKDIR/ownertrust.txt" ]]; then
    echo "==> Importing owner trust database..."
    gpg --import-ownertrust "$WORKDIR/ownertrust.txt"
  fi

  if [[ -d "$WORKDIR/revocation-certs" ]] && [[ -n "$(ls -A "$WORKDIR/revocation-certs" 2>/dev/null)" ]]; then
    echo "==> Restoring revocation certificates..."
    mkdir -p "$HOME/.gnupg/openpgp-revocs.d"
    cp "$WORKDIR"/revocation-certs/*.rev "$HOME/.gnupg/openpgp-revocs.d/" 2>/dev/null || true
  fi

  echo
  echo "==> Done. Keys imported into your GPG keyring."
  echo "  Run 'gpg --list-secret-keys' to confirm."
}

# --- main ---

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
