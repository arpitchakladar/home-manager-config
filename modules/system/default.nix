# System monitoring tools
{ ... }:
{
  imports = [
    ./bottom
    ./brightnessctl
    ./htop
    ./nvtop
    ./systemctl-tui
  ];
}
