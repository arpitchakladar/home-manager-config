# Clipboard utilities for Wayland compositors
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktop.wl-clipboard = {
    package = lib.mkPackageOption pkgs "wl-clipboard" { };
  };

  config = lib.mkIf config.desktop.enable {
    home.packages = [ config.desktop.wl-clipboard.package ];
  };
}
