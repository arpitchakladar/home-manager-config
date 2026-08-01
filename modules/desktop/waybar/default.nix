{
  config,
  lib,
  pkgs,
  ...
}:
{
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
