# System monitoring tools
{ ... }:
{
  imports = [
    ./brightnessctl
    ./btop
    ./deep-clean
    ./htop
    ./nix-update
    ./nvtop
    ./systemctl-tui
  ];
}
