# Desktop - Desktop environment configuration (Hyprland, GTK, waybar)
{
  lib,
  config,
  ...
}:
{
  imports = [
    ./gtk
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
