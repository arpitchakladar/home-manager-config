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
    ./wl-clipboard
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
