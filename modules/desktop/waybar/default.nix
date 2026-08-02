{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktop.waybar = {
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.waybar.package;
      description = "The waybar package to use.";
    };
  };

  config = lib.mkIf config.desktop.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = lib.mkMerge [
        (import ./bar { inherit config; })
        (import ./module { inherit config lib pkgs; })
      ];

      style = builtins.readFile (
        config.scheme {
          template = builtins.readFile ./style.mustache.css;
          extension = ".css";
        }
      );
    };
  };
}
