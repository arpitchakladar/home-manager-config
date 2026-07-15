{
  config,
  lib,
  pkgs,
  ...
}:

# brightnessctl - Backlight brightness control tool
{
  options.system.brightnessctl = {
    enable = lib.mkEnableOption "Enables brightnessctl.";
    package = lib.mkPackageOption pkgs "brightnessctl" { };
  };

  config = lib.mkIf config.system.brightnessctl.enable {
    home.packages = [ config.system.brightnessctl.package ];
  };
}
