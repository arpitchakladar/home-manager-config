{
  config,
  lib,
  pkgs,
  ...
}:

# brightnessctl - Backlight brightness control tool
{
  options.programs.brightnessctl = {
    enable = lib.mkEnableOption "Enables brightnessctl.";
    package = lib.mkPackageOption pkgs "brightnessctl" { };
  };

  config = lib.mkIf config.programs.brightnessctl.enable {
    home.packages = [ config.programs.brightnessctl.package ];
  };
}
