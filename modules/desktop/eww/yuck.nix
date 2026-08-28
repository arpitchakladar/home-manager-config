{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../../lib/script.nix { inherit lib pkgs; })) mkPythonScript;
in
{
  config = lib.mkIf config.desktop.enable {
    programs.eww.yuckConfig =
      let
        system-stats = mkPythonScript {
          name = "eww-system-stats";
          path = ./system-stats.py;
          description = "Emit {cpu, ram, net} as JSON.";
          deps = [
            pkgs.iw
            pkgs.iproute2
            pkgs.pamixer
            pkgs.inotify-tools
            pkgs.dmidecode
          ];
        };

        workspaces = mkPythonScript {
          name = "eww-workspaces";
          path = ./workspaces.py;
          description = "Emit workspace list with each focused-app icon, driven by niri's event-stream.";
          pythonPackages = (ps: [ ps.pygobject3 ]);
          deps = [ config.desktop.niri.package ];
          gobjectIntrospection = true;
        };

        activate-windows = mkPythonScript {
          name = "eww-activate-windows";
          path = ./activate-windows.py;
          description = "Emit icons for windows on the active niri workspace via event-stream.";
          pythonPackages = (ps: [ ps.pygobject3 ]);
          deps = [ config.desktop.niri.package ];
          gobjectIntrospection = true;
        };
      in
      builtins.replaceStrings
        [
          "@@workspaces-script@@"
          "@@windows-script@@"
          "@@systemstats-script@@"
          "@@icon-offline@@"
          "@@icon-wifi@@"
          "@@icon-ethernet@@"
          "@@icon-cpu@@"
          "@@icon-ram@@"
          "@@icon-audio@@"
          "@@icon-calendar@@"
        ]
        [
          (lib.getExe workspaces)
          (lib.getExe activate-windows)
          (lib.getExe system-stats)
          (toString ../../../assets/icons/bar/offline.svg)
          (toString ../../../assets/icons/bar/wifi.svg)
          (toString ../../../assets/icons/bar/ethernet.svg)
          (toString ../../../assets/icons/bar/cpu.svg)
          (toString ../../../assets/icons/bar/ram.svg)
          (toString ../../../assets/icons/bar/audio.svg)
          (toString ../../../assets/icons/bar/calendar.svg)
        ]
        (builtins.readFile ./bar.yuck);
  };
}
