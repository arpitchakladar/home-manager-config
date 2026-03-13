{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.desktop.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = with config.scheme.withHashtag; {
        modifier = "Mod4"; # Super

        bars = [ ];

        gaps = {
          inner = 10;
          outer = 0;
        };

        window = {
          border = 1;
          titlebar = false;
        };

        colors = {
          focused = {
            border = base03;
            background = base03;
            text = base07;
            indicator = base03;
            childBorder = base03;
          };
          focusedInactive = {
            border = base02;
            background = base02;
            text = base05;
            indicator = base02;
            childBorder = base02;
          };
          unfocused = {
            border = base02;
            background = base02;
            text = base05;
            indicator = base02;
            childBorder = base02;
          };
        };

        defaultWorkspace = "1";

        window.commands = [
          {
            command = "floating enable, sticky enable, resize set 1000 600, move position center";
            criteria = {
              class = "floating-termial";
            };
          }
        ];

        focus.followMouse = true;

        startup = [
          # {
          #   command = "${config.services.polybar.script}";
          #   always = true;
          #   notification = false;
          # }
          {
            command = "xrandr -q | grep -w 'connected' | cut -d' ' -f1 | xargs -I{} i3-msg \"workspace 1 output {}\"";
            always = false;
            notification = false;
          }
          {
            command =
              if config.tools.feh.enable then
                "${pkgs.feh}/bin/feh --bg-scale ${../../../assets/skeleton-mage.png}"
              else
                "xsetroot -solid \"${config.scheme.withHashtag.base00}\"";
            always = true;
            notification = false;
          }
        ];

        keybindings = lib.mkOptionDefault (import ./keybindings.nix { inherit pkgs lib; });
      };
      extraConfig = ''
        exec_always --no-startup-id xrandr -q | grep -w 'connected' | cut -d' ' -f1 | xargs -I{} i3-msg "workspace 1 output {}"
        set $ws1  "workspace number 1"
        set $ws2  "workspace number 2"
        set $ws3  "workspace number 3"
        set $ws4  "workspace number 4"
        set $ws5  "workspace number 5"
        set $ws6  "workspace number 6"
        set $ws7  "workspace number 7"
        set $ws8  "workspace number 8"
        set $ws9  "workspace number 9"
        set $ws10 "workspace number 10"
        exec_always --no-startup-id "i3-msg 'workspace 1; workspace 2; workspace 3; workspace 4; workspace 5; workspace 6; workspace 7; workspace 8; workspace 9; workspace 10; workspace 1' && polybar-msg cmd restart"
      '';
    };
  };
}
