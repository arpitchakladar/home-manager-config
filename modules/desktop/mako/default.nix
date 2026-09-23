# mako notification daemon
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.mako;
in
{
  imports = [ ./colors.nix ];

  options.desktop.mako = {
    enable = lib.mkEnableOption "Enables mako.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.services.mako.package or pkgs.mako;
      description = "The mako package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
      settings = {
        font = "${config.fonts.normal} ${toString config.fonts.size}";
        margin = 10;
        padding = 8;
        border-size = 1;
        border-radius = 0;
        max-icon-size = 32;
        icons = true;
        markup = true;
        actions = true;
        format = "<b>%s</b>\\n%b";
        default-timeout = 5000;
      };
    };
  };
}
