# Desktop - Desktop environment configuration (i3/Hyprland, GTK, polybar)
{
  lib,
  config,
  ...
}:
{
  imports = [
    ./gtk
    ./polybar
    ./xdg
    ./hyprland
  ];

  options.desktop = {
    enable = lib.mkEnableOption "Enables graphical interface.";
  };

  config = lib.mkIf config.desktop.enable {
    xdg.enable = true;
  };
}
