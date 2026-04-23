{
  config,
  lib,
  pkgs,
  ...
}:

# i3 - Window manager configuration (gaps, colors, startup, keybindings)
{
  config = lib.mkIf config.desktop.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = with config.scheme.withHashtag; {
        modifier = "Mod4"; # Super

        bars = [ ];

        gaps = {
          inner = 10;
          top = 50; # NOTE: Based on height of polybar
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

        defaultWorkspace = "workspace number 1";

        window.commands = [
          {
            command = "floating enable, sticky enable, resize set 1400 800, move position center";
            criteria.class = "file-explorer";
          }
          {
            command = "floating enable, sticky enable, resize set 1000 600, move position center";
            criteria.class = "application-launcher";
          }
          {
            command = "floating enable, sticky enable, resize set 1000 600, move position center";
            criteria.class = "keybindings-viewer";
          }
        ];

        focus.followMouse = true;

        startup = [
          {
            command = "xrandr -q | grep -w 'connected' | cut -d' ' -f1 | xargs -I{} i3-msg \"workspace 1 output {}\"";
            always = false;
            notification = false;
          }
          {
            command =
              if config.programs.feh.enable then
                "${lib.getExe pkgs.feh} --bg-scale ${../../../assets/sapling.png}"
              else
                "xsetroot -solid \"${config.scheme.withHashtag.base00}\"";
            always = true;
            notification = false;
          }
        ];

        keybindings = lib.mkOptionDefault (
          import ./keybindings.nix {
            inherit
              pkgs
              lib
              config
              ;
          }
        );
      };
      extraConfig = ''
        exec_always --no-startup-id xrandr -q | grep -w 'connected' | cut -d' ' -f1 | xargs -I{} i3-msg "workspace 1 output {}"
        exec_always --no-startup-id "polybar-msg cmd restart"
      '';
    };
  };
}
