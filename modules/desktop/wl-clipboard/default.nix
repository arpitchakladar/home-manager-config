# Clipboard utilities for Wayland compositors
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktop.wl-clipboard = {
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.wl-clipboard;
      description = "The wl-clipboard package to use.";
    };
  };

  config = lib.mkIf config.desktop.enable {
    home.packages = [ config.desktop.wl-clipboard.package ];
  };
}
