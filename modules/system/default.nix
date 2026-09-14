# System monitoring tools
{ ... }:
{
  imports = [
    ./brightnessctl
    ./btop
    ./deep-clean
    ./nix-update
    ./systemctl-tui
  ];
}
