{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../lib.nix { inherit lib; }) mkIcon;
in
{
  mainBar = {
    "battery" = import ./battery.nix { inherit config mkIcon; };
    "cpu" = import ./cpu.nix { inherit config mkIcon; };
    "clock#date" = import ./date.nix { inherit config mkIcon; };
    "memory" = import ./memory.nix { inherit config mkIcon; };
    "network" = import ./network.nix { inherit config mkIcon; };
    "clock#time" = import ./time.nix { inherit config mkIcon; };
    "pulseaudio" = import ./volume.nix { inherit config mkIcon; };
    "custom/vpn" = import ./vpn.nix {
      inherit
        config
        lib
        pkgs
        mkIcon
        ;
    };
    "hyprland/window" = import ./window.nix { inherit config; };
    "hyprland/workspaces" = import ./workspaces.nix { inherit config lib mkIcon; };
  };
}
