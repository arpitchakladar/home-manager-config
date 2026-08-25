# Desktop environment configuration
{
  lib,
  config,
  ...
}:
{
  imports = [
    ./rofi
    ./wl-clipboard
    ./xdg
    ./niri
    ./eww
  ];

  options.desktop = {
    enable = lib.mkEnableOption "Enables graphical interface.";
  };

  config = lib.mkIf config.desktop.enable {
    xdg.enable = true;
  };
}
