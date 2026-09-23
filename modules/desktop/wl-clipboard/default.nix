# Clipboard utilities for Wayland compositors
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.wl-clipboard;
in
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
    home.packages = [ cfg.package ];
  };
}
