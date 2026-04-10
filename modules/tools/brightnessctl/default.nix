{
  config,
  lib,
  pkgs,
  ...
}:

# brightnessctl - Backlight brightness control tool
{
  options.tools.brightnessctl = {
    enable = lib.mkEnableOption "Enables brightnessctl.";
  };

  config = lib.mkIf config.tools.brightnessctl.enable {
    home.packages = with pkgs; [
      brightnessctl
    ];
  };
}
