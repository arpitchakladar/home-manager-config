#!/usr/bin/env bash
set -euo pipefail

echo "--- Starting Nix Deep Clean (keeping only current generations) ---"

if [[ $EUID -eq 0 ]]; then
  echo "Error: Do not run this script with sudo."
  echo "Run it as your normal user; it will ask for sudo when required."
  exit 1
fi

echo "Removing old NixOS system generations..."
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +1

echo "Removing old Home Manager generations..."
if command -v home-manager &> /dev/null; then
  home-manager generations | \
    awk 'NR>1 {print $1}' | \
    xargs -r home-manager remove-generations
fi

echo "Removing old user profile generations..."
nix-env --delete-generations +1

echo "Removing result symlinks..."
find . -name "result" -type l -delete

echo "Running garbage collector..."
sudo nix-collect-garbage -d
nix-collect-garbage -d

echo "Optimising Nix store..."
nix store optimise

echo "--- Cleanup Complete ---"
