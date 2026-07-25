# Grim - Screenshot utility for wlroots Wayland compositors
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.media.grim = {
    enable = lib.mkEnableOption "Enables grim.";
    package = lib.mkPackageOption pkgs "grim" { };
  };

  config = lib.mkIf config.media.grim.enable {
    home.packages = [ config.media.grim.package ];
  };
}
