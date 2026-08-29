# Backlight brightness control tool
{
  config,
  lib,
  pkgs,
  ...
}:
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

  config = lib.mkIf config.system.brightnessctl.enable {
    home.packages = [ config.system.brightnessctl.package ];
  };
}
