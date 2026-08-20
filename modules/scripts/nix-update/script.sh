#!/usr/bin/env bash

set -euo pipefail

HM_DIR="$HOME/.config/home-manager"
NIXOS_DIR="/etc/nixos"
FLAKE_ONLY=false
TARGET=""

usage() {
  echo "Usage: nix-update <home-manager|nixos|both> [--flake-only]"
  echo ""
  echo "Options:"
  echo "  home-manager   Update and switch home-manager configuration"
  echo "  nixos          Update and switch NixOS configuration"
  echo "  both           Update and switch both configurations"
  echo ""
  echo "Flags:"
  echo "  --flake-only   Only run nix flake update, skip switch commands"
  exit 1
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      home-manager | nixos | both)
        if [[ -n "$TARGET" ]]; then
          echo "Error: only one target allowed"
          usage
        fi
        TARGET="$1"
        shift
        ;;
      --flake-only)
        FLAKE_ONLY=true
        shift
        ;;
      -h | --help)
        usage
        ;;
      *)
        echo "Error: unknown option '$1'"
        usage
        ;;
    esac
  done

  if [[ -z "$TARGET" ]]; then
    echo "Error: no target specified"
    usage
  fi
}

update_home_manager() {
  echo "==> Updating home-manager..."
  cd "$HM_DIR"

  echo "    Staging modules/private..."
  git add modules/private -f

  echo "    Running nix flake update..."
  nix flake update

  if [[ "$FLAKE_ONLY" == false ]]; then
    echo "    Running home-manager switch..."
    home-manager switch --flake "$HM_DIR#arpit"
  fi

  echo "    Unstaging modules/private..."
  git rm --cached -r modules/private

  echo "==> home-manager update complete"
}

update_nixos() {
  echo "==> Updating NixOS..."
  sudo -v
  cd "$NIXOS_DIR"

  echo "    Staging hardware-configuration.nix..."
  git add hardware-configuration.nix -f

  echo "    Running nix flake update..."
  nix flake update

  if [[ "$FLAKE_ONLY" == false ]]; then
    echo "    Running nixos-rebuild switch..."
    sudo nixos-rebuild switch
  fi

  echo "    Unstaging hardware-configuration.nix..."
  git rm --cached hardware-configuration.nix

  echo "==> NixOS update complete"
}

parse_args "$@"

case "$TARGET" in
  home-manager)
    update_home_manager
    ;;
  nixos)
    update_nixos
    ;;
  both)
    update_nixos
    update_home_manager
    ;;
esac
