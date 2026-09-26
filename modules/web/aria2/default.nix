# Command line download manager
{
  config,
  lib,
  ...
}:
let
  cfg = config.web.aria2;
  icons = config.desktop.icons.apps;
in
{
  options.web.aria2 = {
    enable = lib.mkEnableOption "Enables aria2.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.aria2.package;
      description = "The aria2 package to use.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.aria2 = {
        enable = true;
        settings = {
          dir = "${config.home.homeDirectory}/Downloads";
        };
        systemd.enable = true;
      };
    })
    (lib.mkIf (cfg.enable && config.desktop.enable) {
      desktop.rofi.action.actions = [
        {
          name = "aria2 Start";
          command = "systemctl --user start aria2";
          icon = icons.aria2;
        }
        {
          name = "aria2 Stop";
          command = "systemctl --user stop aria2";
          icon = icons.aria2;
        }
      ];
    })
  ];
}
