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

      style = import ./style.nix { inherit config; };
    };
  };
}
