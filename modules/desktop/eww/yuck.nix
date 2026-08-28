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
        pythonEnv = pkgs.python3.withPackages (ps: [ ps.pygobject3 ]);
        system-stats = pkgs.stdenv.mkDerivation {
          pname = "eww-system-stats";
          version = "0.1.0";
          src = ./system-stats.py;
          dontUnpack = true;
          meta.mainProgram = "eww-system-stats";

          nativeBuildInputs = [
            pkgs.iw
            pkgs.pamixer
            pkgs.wrapGAppsHook3
            pkgs.gobject-introspection
          ];
          buildInputs = [ pkgs.gtk3 ];

          installPhase = ''
            mkdir -p $out/bin
            install -m755 $src $out/bin/eww-system-stats
            patchShebangs $out/bin/eww-system-stats
          '';

          # wrapGAppsHook3 wraps every executable in $out/bin automatically,
          # setting GI_TYPELIB_PATH etc. from buildInputs' closure.
          preFixup = ''
            gappsWrapperArgs+=(--prefix PATH : "${pythonEnv}/bin")
          '';
        };

        workspaces = pkgs.stdenv.mkDerivation {
          pname = "eww-workspaces";
          version = "0.1.0";
          src = ./workspaces.py;
          dontUnpack = true;
          meta.mainProgram = "eww-workspaces";

          nativeBuildInputs = [
            pkgs.wrapGAppsHook3
            pkgs.gobject-introspection
          ];
          buildInputs = [ pkgs.gtk3 ];

          installPhase = ''
            mkdir -p $out/bin
            install -m755 $src $out/bin/eww-workspaces
            patchShebangs $out/bin/eww-workspaces
          '';

          # wrapGAppsHook3 wraps every executable in $out/bin automatically,
          # setting GI_TYPELIB_PATH etc. from buildInputs' closure.
          preFixup = ''
            gappsWrapperArgs+=(--prefix PATH : "${pythonEnv}/bin")
          '';
        };

        activate-windows = pkgs.stdenv.mkDerivation {
          pname = "eww-activate-windows";
          version = "0.1.0";
          src = ./activate-windows.py;
          dontUnpack = true;
          meta.mainProgram = "eww-activate-windows";

          nativeBuildInputs = [
            pkgs.wrapGAppsHook3
            pkgs.gobject-introspection
          ];
          buildInputs = [ pkgs.gtk3 ];

          installPhase = ''
            mkdir -p $out/bin
            install -m755 $src $out/bin/eww-activate-windows
            patchShebangs $out/bin/eww-activate-windows
          '';

          # wrapGAppsHook3 wraps every executable in $out/bin automatically,
          # setting GI_TYPELIB_PATH etc. from buildInputs' closure.
          preFixup = ''
            gappsWrapperArgs+=(--prefix PATH : "${pythonEnv}/bin")
          '';
        };
      in
      builtins.replaceStrings
        [
          "@@workspaces-script@@"
          "@@windows-script@@"
          "@@systemstats-script@@"
          "@@icon-unknown@@"
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
          (toString ../../../assets/icons/unknown.svg)
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
