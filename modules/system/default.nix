# System monitoring tools
{ ... }:
{
  imports = [
    ./brightnessctl
    ./btop
    ./deep-clean
    ./htop
    ./nix-update
    ./systemctl-tui
  ];
}
