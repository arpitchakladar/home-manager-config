#!/usr/bin/env bash

set -euo pipefail

info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m==> warning:\033[0m %s\n' "$*" >&2; }
error() { printf '\033[1;31m==> error:\033[0m %s\n' "$*" >&2; }
die()   { error "$*"; exit 1; }

HM_DIR="$HOME/.config/home-manager"
NIXOS_DIR="/etc/nixos"
ONLY_FLAKE=false
ONLY_SWITCH=false
TARGET=""

usage() {
  echo "Usage: $0 <home-manager|nixos|both> [--only-flake|--only-switch]"
  echo ""
  echo "Commands:"
  echo "  home-manager   Update and switch home-manager configuration"
  echo "  nixos          Update and switch NixOS configuration"
  echo "  both           Update and switch both configurations"
  echo ""
  echo "Options:"
  echo "  --only-flake   Only run nix flake update, skip switch commands"
  echo "  --only-switch  Only run switch commands, skip nix flake update"
  exit 1
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      home-manager | nixos | both)
        if [[ -n "$TARGET" ]]; then
          error "only one target allowed"
          usage
        fi
        TARGET="$1"
        shift
        ;;
      --only-flake)
        ONLY_FLAKE=true
        shift
        ;;
      --only-switch)
        ONLY_SWITCH=true
        shift
        ;;
      -h | --help)
        usage
        ;;
      *)
        error "unknown option '$1'"
        usage
        ;;
    esac
  done

  if [[ -z "$TARGET" ]]; then
    error "no target specified"
    usage
  fi
}

update_home_manager() {
  info "Updating home-manager..."
  cd "$HM_DIR"

  info "Staging users/arpit/private.nix..."
  git add users/arpit/private.nix -f

  trap 'git rm --cached users/arpit/private.nix >/dev/null 2>&1 || true' EXIT INT TERM HUP

  if [[ "$ONLY_SWITCH" == false ]]; then
    info "Running nix flake update..."
    nix flake update
  fi

  if [[ "$ONLY_FLAKE" == false ]]; then
    info "Running home-manager switch..."
    home-manager switch --flake "$HM_DIR#arpit"
  fi

  info "Unstaging users/arpit/private.nix..."
  git rm --cached users/arpit/private.nix

  trap - EXIT INT TERM HUP

  info "home-manager update complete"
}

update_nixos() {
  info "Updating NixOS..."
  sudo -v
  cd "$NIXOS_DIR"

  info "Staging hardware-configuration.nix..."
  git add hardware-configuration.nix -f

  trap 'git rm --cached hardware-configuration.nix >/dev/null 2>&1 || true' EXIT INT TERM HUP

  if [[ "$ONLY_SWITCH" == false ]]; then
    info "Running nix flake update..."
    nix flake update
  fi

  if [[ "$ONLY_FLAKE" == false ]]; then
    info "Running nixos-rebuild switch..."
    sudo nixos-rebuild switch
  fi

  info "Unstaging hardware-configuration.nix..."
  git rm --cached hardware-configuration.nix

  trap - EXIT INT TERM HUP

  info "NixOS update complete"
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
