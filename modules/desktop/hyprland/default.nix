{
  config,
  lib,
  pkgs,
  ...
}:
let
  toHyprColor = hex: "rgba(${lib.removePrefix "#" hex}ff)";
in
{
  imports = [
    ./hyprpaper.nix
    ./keybindings.nix
  ];

  config = lib.mkIf config.desktop.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      xwayland.enable = true;
      systemd.enable = true;

      settings = {
        mainMod = {
          _var = "SUPER";
        };

        config = {
          general = with config.scheme.withHashtag; {
            gaps_in = 5;
            gaps_out = 5;
            border_size = 1;
            col = {
              active_border = {
                colors = [ (toHyprColor base03) ];
                angle = 45;
              };
              inactive_border = toHyprColor base00;
            };
            layout = "dwindle";
          };

          decoration = {
            rounding = 0;
          };

          input = {
            follow_mouse = 1;
            kb_layout = "us";
          };

          cursor = {
            enable_hyprcursor = true;
          };

          dwindle = {
            preserve_split = true;
          };
        };

        window_rule = [
          {
            name = "float-file-explorer";
            match.class = "^(file-explorer)$";
            float = true;
          }
          {
            name = "size-file-explorer";
            match.class = "^(file-explorer)$";
            size = "1280 720";
          }
          {
            name = "center-file-explorer";
            match.class = "^(file-explorer)$";
            center = true;
          }

          {
            name = "float-rofi";
            match.class = "^(rofi)$";
            float = true;
          }
          {
            name = "size-rofi";
            match.class = "^(rofi)$";
            size = "800 600";
          }
          {
            name = "center-rofi";
            match.class = "^(rofi)$";
            center = true;
          }

          {
            name = "float-keybindings-viewer";
            match.class = "^(keybindings-viewer)$";
            float = true;
          }
          {
            name = "size-keybindings-viewer";
            match.class = "^(keybindings-viewer)$";
            size = "1280 720";
          }
          {
            name = "center-keybindings-viewer";
            match.class = "^(keybindings-viewer)$";
            center = true;
          }
        ];
      };
    };

    home.pointerCursor = {
      enable = true;
      package = pkgs.rose-pine-hyprcursor;
      name = "rose-pine-hyprcursor";
      size = 20;
      hyprcursor.enable = true;
      gtk.enable = false;
      x11.enable = false;
    };

    home.packages = with pkgs; [
      grim
      slurp
      wl-clipboard
    ];
  };
}
