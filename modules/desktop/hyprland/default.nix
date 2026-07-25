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
    ./keybindings.nix
  ];

  options.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland Wayland compositor";
  };

  config = lib.mkIf config.desktop.hyprland.enable {
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
                colors = [ (toHyprColor base07) ];
                angle = 45;
              };
              inactive_border = toHyprColor base03;
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
            name = "float-application-launcher";
            match.class = "^(application-launcher)$";
            float = true;
          }
          {
            name = "size-application-launcher";
            match.class = "^(application-launcher)$";
            size = "800 600";
          }
          {
            name = "center-application-launcher";
            match.class = "^(application-launcher)$";
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

    services.hyprpaper = lib.mkIf config.media.feh.enable {
      enable = true;
      settings = {
        preload = [ "${../../../assets/sapling.png}" ];
        wallpaper = [ ",${../../../assets/sapling.png}" ];
      };
    };

    home.packages = with pkgs; [
      grim
      slurp
      wl-clipboard
    ];
  };
}
