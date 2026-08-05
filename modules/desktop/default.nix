# Desktop environment configuration
{
  lib,
  config,
  ...
}:
{
  imports = [
    ./darkman
    ./rofi
    ./xdg
    ./hyprland
    ./waybar
  ];

  options.desktop = {
    enable = lib.mkEnableOption "Enables graphical interface.";
  };

  config = lib.mkIf config.desktop.enable {
    xdg.enable = true;
  };
}
