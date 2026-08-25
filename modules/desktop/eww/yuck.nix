{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.desktop.enable {
    home.file.".config/eww/icons/fallback.svg".text = ''
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
        <rect x="2" y="2" width="20" height="20" rx="3" fill="none" stroke="#c8ccd4" stroke-width="2"/>
      </svg>
    '';

    programs.eww.yuckConfig =
      let
        workspaces = pkgs.writeShellApplication {
          name = "eww-workspaces";
          # This automatically adds these packages to the script's PATH
          runtimeInputs = with pkgs; [
            niri
            jq
          ];

          text = ''
            #!/usr/bin/env bash
            # Outputs JSON array of workspaces for eww bar
            niri msg -j workspaces | jq -c 'sort_by(.idx)'
          '';
        };
      in
      ''
        (defpoll time :interval "10s" "date '+%H:%M'")
        (defpoll date :interval "60s" "date '+%d/%m'")
        (defpoll workspaces :interval "1s" :initial "[]" "${lib.getExe workspaces}")
        (defpoll active-windows :interval "1s" "${lib.getExe config.scripts.eww-active-windows.package}")

        (defwindow bar
          :monitor 0
          :geometry (geometry
                      :x "0px"
                      :y "0px"
                      :width "50px"
                      :height "100%"
                      :anchor "top right")
          :stacking "fg"
          :focusable "none"
          :reserve (struts :distance "50px" :side "right")
          (bar-content))

        (defwidget bar-content []
          (box :orientation "v" :space-evenly false :class "bar-container"
            (box :orientation "v" :space-evenly false :valign "start" :class "top-section"
              (workspaces-widget)
              (windows-widget))))

        (defwidget workspaces-widget []
          (box :orientation "v" :space-evenly false :spacing 4 :halign "center" :class "workspaces"
            (for ws in workspaces
              (button :class {ws.is_active ? "ws-active" : "ws-inactive"}
                      :onclick "niri msg action focus-workspace ''${ws.idx}"
                (label :text "''${ws.idx}")))))

        (defwidget windows-widget []
          (box :orientation "v" :space-evenly false :spacing 4 :halign "center" :class "windows"
            (image :class "win-icon" :path "/tmp/test-icon.svg" :image-width 20 :image-height 20)))
      '';
  };
}
