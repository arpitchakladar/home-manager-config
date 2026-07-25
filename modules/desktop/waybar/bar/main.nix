{ config }:
with config.scheme.withHashtag;
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
    "custom/vpn"
    "network"
    "memory"
    "cpu"
    "clock#time"
    "clock#date"
  ];
}
