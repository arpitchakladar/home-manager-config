# Slurp - Region selector for wlroots Wayland compositors (used by grim)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.media.slurp = {
    enable = lib.mkEnableOption "Enables slurp.";
    package = lib.mkPackageOption pkgs "slurp" { };
  };

  config = lib.mkIf config.media.slurp.enable {
    home.packages = [ config.media.slurp.package ];
  };
}
