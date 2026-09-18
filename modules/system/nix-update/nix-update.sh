#!/usr/bin/env bash
# Update and switch the home-manager and/or NixOS configurations.

set -euo pipefail

info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m==> warning:\033[0m %s\n' "$*" >&2; }
error() { printf '\033[1;31m==> error:\033[0m %s\n' "$*" >&2; }
die()   { error "$*"; exit 1; }

HOME_MANAGER_CONFIG_DIR="$HOME/.config/home-manager"
NIXOS_CONFIG_DIR="/etc/nixos"
ONLY_UPDATE_FLAKE_INPUTS=false
ONLY_SWITCH_CONFIGURATION=false
UPDATE_TARGET=""

print_usage() {
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

parse_command_line_arguments() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      home-manager | nixos | both)
        if [[ -n "$UPDATE_TARGET" ]]; then
          error "only one target allowed"
          print_usage
        fi
        UPDATE_TARGET="$1"
        shift
        ;;
      --only-flake)
        ONLY_UPDATE_FLAKE_INPUTS=true
        shift
        ;;
      --only-switch)
        ONLY_SWITCH_CONFIGURATION=true
        shift
        ;;
      -h | --help)
        print_usage
        ;;
      *)
        error "unknown option '$1'"
        print_usage
        ;;
    esac
  done

  if [[ -z "$UPDATE_TARGET" ]]; then
    error "no target specified"
    print_usage
  fi
}

update_home_manager_configuration() {
  info "Updating home-manager..."
  cd "$HOME_MANAGER_CONFIG_DIR"

  info "Staging users/arpit/private.nix..."
  git add users/arpit/private.nix -f

  trap 'git rm --cached users/arpit/private.nix >/dev/null 2>&1 || true' EXIT INT TERM HUP

  if [[ "$ONLY_SWITCH_CONFIGURATION" == false ]]; then
    info "Running nix flake update..."
    nix flake update
  fi

  if [[ "$ONLY_UPDATE_FLAKE_INPUTS" == false ]]; then
    info "Running home-manager switch..."
    home-manager switch --flake "$HOME_MANAGER_CONFIG_DIR#arpit"
  fi

  info "Unstaging users/arpit/private.nix..."
  git rm --cached users/arpit/private.nix

  trap - EXIT INT TERM HUP

  info "home-manager update complete"
}

update_nixos_configuration() {
  info "Updating NixOS..."
  sudo -v
  cd "$NIXOS_CONFIG_DIR"

  info "Staging hardware-configuration.nix..."
  git add hardware-configuration.nix -f

  trap 'git rm --cached hardware-configuration.nix >/dev/null 2>&1 || true' EXIT INT TERM HUP

  if [[ "$ONLY_SWITCH_CONFIGURATION" == false ]]; then
    info "Running nix flake update..."
    nix flake update
  fi

  if [[ "$ONLY_UPDATE_FLAKE_INPUTS" == false ]]; then
    info "Running nixos-rebuild switch..."
    sudo nixos-rebuild switch
  fi

  info "Unstaging hardware-configuration.nix..."
  git rm --cached hardware-configuration.nix

  trap - EXIT INT TERM HUP

  info "NixOS update complete"
}

parse_command_line_arguments "$@"

case "$UPDATE_TARGET" in
  home-manager)
    update_home_manager_configuration
    ;;
  nixos)
    update_nixos_configuration
    ;;
  both)
    update_nixos_configuration
    update_home_manager_configuration
    ;;
esac
