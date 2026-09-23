# Backlight brightness control tool
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.system.brightnessctl;
in
{
  options.system.brightnessctl = {
    enable = lib.mkEnableOption "Enables brightnessctl.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.brightnessctl;
      description = "The brightnessctl package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
