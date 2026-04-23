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
  };

  config = lib.mkIf config.programs.brightnessctl.enable {
    home.packages = with pkgs; [
      brightnessctl
    ];
  };
}
