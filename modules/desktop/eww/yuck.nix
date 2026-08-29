{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.desktop.enable {
    programs.eww.yuckConfig =
      let
        mkPythonScript =
          {
            name,
            path,
            description ? "",
            python ? pkgs.python3,
            pythonPackages ? (ps: [ ]),
            deps ? [ ],
            gobjectIntrospection ? false,
          }:
          let
            pythonEnv = python.withPackages pythonPackages;
            pathPrefix = lib.concatStringsSep ":" (
              [ "${pythonEnv}/bin" ] ++ map (p: "${lib.getBin p}/bin") deps
            );
          in
          pkgs.stdenv.mkDerivation {
            pname = name;
            version = "0.1.0";
            src = path;
            dontUnpack = true;
            meta = lib.optionalAttrs (description != "") { inherit description; } // {
              mainProgram = name;
            };

            nativeBuildInputs =
              lib.optionals gobjectIntrospection [
                pkgs.wrapGAppsHook3
                pkgs.gobject-introspection
              ]
              ++ lib.optional (!gobjectIntrospection) pkgs.makeWrapper;
            buildInputs = lib.optionals gobjectIntrospection [ pkgs.gtk3 ];

            installPhase = ''
              mkdir -p $out/bin
              install -m755 $src $out/bin/${name}
              patchShebangs $out/bin/${name}
            '';

            # wrapGAppsHook3 wraps every executable in $out/bin automatically,
            # setting GI_TYPELIB_PATH etc. from buildInputs' closure. With
            # gobjectIntrospection = false a plain wrapProgram only extends PATH.
            preFixup =
              if gobjectIntrospection then
                ''
                  gappsWrapperArgs+=(--prefix PATH : "${pathPrefix}")
                ''
              else
                ''
                  wrapProgram $out/bin/${name} --prefix PATH : "${pathPrefix}"
                '';
          };

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
          "@@icon-proxy@@"
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
          (toString ../../../assets/icons/bar/proxy.svg)
          (toString ../../../assets/icons/bar/cpu.svg)
          (toString ../../../assets/icons/bar/ram.svg)
          (toString ../../../assets/icons/bar/audio.svg)
          (toString ../../../assets/icons/bar/calendar.svg)
        ]
        (builtins.readFile ./bar.yuck);
  };
}
