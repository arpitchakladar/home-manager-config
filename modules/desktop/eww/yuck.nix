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
        mkLuaScript =
          {
            name,
            path,
            description ? "",
            lua ? pkgs.luajit,
            luaPackages ? (_: [ ]),
            deps ? [ ],
            gobjectIntrospection ? false,
          }:
          let
            luaEnv = lua.withPackages luaPackages;
            pathPrefix = lib.concatStringsSep ":" ([ "${luaEnv}/bin" ] ++ map (p: "${lib.getBin p}/bin") deps);
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

        system-stats = mkLuaScript {
          name = "eww-system-stats";
          path = ./system-stats.lua;
          description = "Emit {cpu, ram, net} as JSON.";
          luaPackages = (
            ps: [
              ps.lua-cjson
              ps.luaposix
            ]
          );
          deps = [
            pkgs.iw
            pkgs.iproute2
            pkgs.pamixer
            pkgs.inotify-tools
            pkgs.dmidecode
          ];
        };

        niri-status = mkLuaScript {
          name = "niri-status";
          path = ./niri-status.lua;
          description = "Emit workspace and active window information list.";
          luaPackages = (
            ps: [
              ps.lgi
              ps.lua-cjson
            ]
          );
          deps = [ config.desktop.niri.package ];
          gobjectIntrospection = true;
        };
      in
      builtins.replaceStrings
        [
          "@@niri-status-script@@"
          "@@system-stats-script@@"
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
          (lib.getExe niri-status)
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
