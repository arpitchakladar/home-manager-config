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
      ''
        (defpoll time :interval "10s" "date '+%H:%M'")
        (defpoll date :interval "60s" "date '+%d/%m'")
        (defpoll full_date :interval "60s" "date '+%A, %d %B %Y'")
        (deflisten workspaces :initial "[]" "${lib.getExe workspaces}")
        (deflisten active-windows :initial "[]" "${lib.getExe activate-windows}")
        (deflisten system_stats
          :initial "{\"cpu\":{\"percent\":0,\"per_core\":[],\"freq_mhz\":null,\"load_avg\":null,\"tooltip\":\"CPU: 0%\"},\"ram\":{\"percent\":0,\"used\":\"0B\",\"total\":\"0B\",\"available\":\"0B\",\"swap_percent\":0,\"swap_used\":\"0B\",\"swap_total\":\"0B\",\"speed_mhz\":null,\"tooltip\":\"RAM: 0%\"},\"net\":{\"status\":\"down\",\"tooltip\":\"Network Offline\",\"routes\":[]},\"sound\":{\"percent\":0,\"mute\":true,\"sink\":null,\"tooltip\":\"Volume: unknown\"}}"
          "${lib.getExe system-stats}")

        (defwindow bar
          :monitor 0
          :geometry (geometry
                      :x "0px"
                      :y "0px"
                      :width "60px"
                      :height "100%"
                      :anchor "top right")
          :stacking "fg"
          :focusable "none"
          :reserve (struts :distance "60px" :side "right")
          (bar-content))

        (defwidget bar-content []
          (box :orientation "v"
               :space-evenly false
               :class "bar-container"
               :vexpand true
            (workspaces-widget)
            (windows-widget)
            (system-widget)))

        (defwidget workspaces-widget []
          (box :orientation "v" :space-evenly false :spacing 4 :halign "fill" :class "workspaces"
            (for ws in workspaces
              (eventbox :onclick "niri msg action focus-workspace ''${ws.idx}"
                        :cursor "pointer" :halign "fill"
                        :tooltip "''${ws.tooltip}"
                (box :class "workspace-button ''${ws.is_active ? 'active' : '''}" :halign "fill"
                  (overlay :halign "fill"
                    (image :class "workspace-icon"
                           :path "''${ws.icon != ''' ? ws.icon : '${../../../assets/icons/unknown.svg}'}"
                           :image-width 20 :image-height 20)
                    (label :class "workspace-idx" :text "''${ws.idx}" :halign "end" :valign "end")))))))

        (defwidget windows-widget []
          (box :orientation "v" :space-evenly false :spacing 4 :halign "center" :class "windows" :vexpand true

            (for w in active-windows
              (eventbox :onclick "niri msg action focus-window --id ''${w.id}"
                        :cursor "pointer"
                        :halign "fill"
                        :tooltip "''${w.app_id}: ''${w.title != ''' ? ' ' : '''}''${w.title}"
                (box :halign "fill" :class "window-button ''${w.is_focused ? 'focused' : '''}"
                  (image :class "window-icon" :path "''${w.icon != ''' ? w.icon : '${../../../assets/icons/unknown.svg}'}" :image-width 20 :image-height 20))))))

        (defwidget system-widget []
          (box :orientation "v" :space-evenly false :spacing 6 :halign "fill" :class "system"
            (box :orientation "v" :class "system-item" :halign "fill" :space-evenly false :spacing 4
                 :tooltip "''${system_stats.net.tooltip}"
              (image :class "system-icon"
                     :path "''${system_stats.net.status == 'down' ? '${../../../assets/icons/bar/offline.svg}' : system_stats.net.routes[0].type == 'wifi' ? '${../../../assets/icons/bar/wifi.svg}' : system_stats.net.routes[0].type == 'ethernet' ? '${../../../assets/icons/bar/ethernet.svg}' : '${../../../assets/icons/bar/offline.svg}'}"
                     :image-width 24 :image-height 24)
              (label :class "system-label small"
                     :text "''${system_stats.net.status == 'down' ? '-' : system_stats.net.routes[0].tx}")
              (label :class "system-label small"
                     :text "''${system_stats.net.status == 'down' ? '-' : system_stats.net.routes[0].rx}"))
            (box :orientation "v" :class "system-item" :space-evenly false :spacing 4
                 :tooltip "''${system_stats.cpu.tooltip}"
              (image :class "system-icon" :path "${../../../assets/icons/bar/cpu.svg}" :image-width 24 :image-height 24)
              (label :class "system-label" :text "''${system_stats.cpu.percent}%"))
            (box :orientation "v" :class "system-item" :space-evenly false :spacing 4
                 :tooltip "''${system_stats.ram.tooltip}"
              (image :class "system-icon" :path "${../../../assets/icons/bar/ram.svg}" :image-width 24 :image-height 24)
              (label :class "system-label" :text "''${system_stats.ram.percent}%"))
            (eventbox :onclick "pamixer --toggle-mute" :cursor "pointer" :halign "fill"
              (box :orientation "v" :space-evenly false :spacing 4 :class "system-item"
                   :tooltip "''${system_stats.sound.tooltip}"
                (image :class "system-icon" :path "${../../../assets/icons/bar/audio.svg}" :image-width 24 :image-height 24)
                (label :class "system-label" :text "''${system_stats.sound.mute ? '-' : (system_stats.sound.percent + '%')}")))
            (box :orientation "v" :class "system-item" :space-evenly false :spacing 4
                 :tooltip "''${full_date} ''${time} (''${date})"
              (image :class "system-icon" :path "${../../../assets/icons/bar/calendar.svg}" :image-width 24 :image-height 24)
              (label :class "system-label small" :text time)
              (label :class "system-label small" :text date))))
      '';
  };
}
