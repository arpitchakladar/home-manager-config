{
  lib,
  ...
}@input:
let
  inherit (import ../lib.nix input) mkIcon icons;

  args = input // {
    inherit mkIcon icons;
  };

  modules = {
    "battery" = ./battery.nix;
    "cpu" = ./cpu.nix;
    "clock#date" = ./date.nix;
    "memory" = ./memory.nix;
    "network" = ./network.nix;
    "clock#time" = ./time.nix;
    "pulseaudio" = ./volume.nix;
    "custom/vpn" = ./vpn.nix;
    "hyprland/window" = ./window.nix;
    "hyprland/workspaces" = ./workspaces.nix;
  };
in
{
  mainBar = lib.mapAttrs (_name: path: import path args) modules;
}
