{
  config,
  lib,
  pkgs,
}:
with config.scheme.withHashtag;
{
  mainBar = {
    "hyprland/workspaces" = import ./workspaces.nix { inherit config; };
    "hyprland/window" = import ./window.nix { inherit config; };
    "pulseaudio" = import ./volume.nix {
      inherit config;
      iconColor = base0A;
    };
    "battery" = import ./battery.nix {
      inherit config;
      iconColor = base09;
    };
    "custom/vpn" = import ./vpn.nix {
      inherit config lib pkgs;
      iconColor = base0C;
    };
    "network" = import ./network.nix {
      inherit config;
      iconColor = base0B;
    };
    "clock#time" = import ./time.nix {
      inherit config;
      iconColor = base08;
    };
    "memory" = import ./memory.nix {
      inherit config;
      iconColor = base0F;
    };
    "cpu" = import ./cpu.nix {
      inherit config;
      iconColor = base0D;
    };
    "clock#date" = import ./date.nix {
      inherit config;
      iconColor = base0E;
    };
  };
}
