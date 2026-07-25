{
  config,
  lib,
  pkgs,
}:
{
  mainBar = {
    "hyprland/workspaces" = import ./workspaces.nix { inherit config; };
    "hyprland/window" = import ./window.nix { inherit config; };
    "pulseaudio" = import ./volume.nix { inherit config; };
    "battery" = import ./battery.nix { inherit config; };
    "custom/vpn" = import ./vpn.nix { inherit config lib pkgs; };
    "network" = import ./network.nix { inherit config; };
    "clock#time" = import ./time.nix { inherit config; };
    "memory" = import ./memory.nix { inherit config; };
    "cpu" = import ./cpu.nix { inherit config; };
    "clock#date" = import ./date.nix { inherit config; };
  };
}
