#compdef nix-update

_arguments \
  '1: :->target' \
  '*:: :->flags'

case $state in
  target)
    local -a commands
    commands=(
      'home-manager:Update and switch home-manager configuration'
      'nixos:Update and switch NixOS configuration'
      'both:Update and switch both configurations'
    )
    _describe 'command' commands
    ;;
  flags)
    _arguments \
      '--only-flake[Only run nix flake update, skip switch commands]' \
      '--only-switch[Only run switch commands, skip nix flake update]'
    ;;
esac
