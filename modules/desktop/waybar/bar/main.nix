{ ... }:
{
  layer = "top";
  position = "top";
  height = 30;

  fixed-center = false;
  expand-center = true;

  modules-left = [ "hyprland/workspaces" ];
  modules-center = [ "hyprland/window" ];
  modules-right = [
    "pulseaudio"
    "battery"
    "network"
    "custom/usque"
    "memory"
    "cpu"
    "clock#time"
    "clock#date"
  ];
}
