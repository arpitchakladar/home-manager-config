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
        workspaces =
          let
            pythonEnv = pkgs.python3.withPackages (ps: [ ps.pygobject3 ]);
          in
          pkgs.stdenv.mkDerivation {
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

        activate-windows =
          let
            pythonEnv = pkgs.python3.withPackages (ps: [ ps.pygobject3 ]);
          in
          pkgs.stdenv.mkDerivation {
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
        (deflisten workspaces :initial "[]" "${lib.getExe workspaces}")
        (deflisten active-windows :initial "[]" "${lib.getExe activate-windows}")

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
            (box :vexpand true)
            (windows-widget)))

        (defwidget workspaces-widget []
          (box :orientation "v" :space-evenly false :spacing 4 :halign "fill" :class "workspaces"
            (for ws in workspaces
              (eventbox :onclick "niri msg action focus-workspace ''${ws.idx}"
                        :cursor "pointer" :halign "fill"
                (box :class "workspace-button ''${ws.is_active ? 'active' : '''}" :halign "fill"
                  (overlay :halign "fill"
                    (image :class "workspace-icon"
                           :path "''${ws.icon != ''' ? ws.icon : '${../../../assets/icons/unknown.svg}'}"
                           :image-width 20 :image-height 20)
                    (label :class "workspace-idx" :text "''${ws.idx}" :halign "end" :valign "end")))))))

        (defwidget windows-widget []
          (box :orientation "v" :space-evenly false :spacing 4 :halign "center" :class "windows"

            (for w in active-windows
              (eventbox :onclick "niri msg action focus-window --id ''${w.id}"
                        :cursor "pointer"
                        :halign "fill"
                        :tooltip "''${w.app_id}: ''${w.title != ''' ? ' ' : '''}''${w.title}"
                (box :halign "fill" :class "window-button ''${w.is_focused ? 'focused' : '''}"
                  (image :class "window-icon" :path "''${w.icon != ''' ? w.icon : '${../../../assets/icons/unknown.svg}'}" :image-width 20 :image-height 20))))))
      '';
  };
}
