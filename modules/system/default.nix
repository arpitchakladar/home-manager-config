# System monitoring tools
{ ... }:
{
  imports = [
    ./bottom
    ./brightnessctl
    ./deep-clean
    ./htop
    ./nix-update
    ./nvtop
    ./system-monitor
    ./systemctl-tui
  ];
}
