#!/usr/bin/env bash
# Remove old NixOS, home-manager and user profile generations, then run
# a full garbage collection and store optimisation.

set -euo pipefail

info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m==> warning:\033[0m %s\n' "$*" >&2; }
error() { printf '\033[1;31m==> error:\033[0m %s\n' "$*" >&2; }
die()   { error "$*"; exit 1; }

info "Starting Nix Deep Clean (keeping only current generations)"

if [[ $EUID -eq 0 ]]; then
  die "Do not run this script with sudo.
Run it as your normal user; it will ask for sudo when required."
fi

info "Removing old NixOS system generations..."
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +1

info "Removing old Home Manager generations..."
if command -v home-manager &> /dev/null; then
  home-manager generations | \
    awk 'NR>1 {print $1}' | \
    xargs -r home-manager remove-generations
fi

info "Removing old user profile generations..."
nix-env --delete-generations +1

info "Removing result symlinks..."
find . -name "result" -type l -delete

info "Running garbage collector..."
sudo nix-collect-garbage -d
nix-collect-garbage -d

info "Optimising Nix store..."
nix store optimise

info "Cleanup Complete."