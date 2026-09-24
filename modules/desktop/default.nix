# Desktop environment configuration
{
  lib,
  config,
  ...
}:
let
  cfg = config.desktop;
in
{
  imports = [
    ./rofi
    ./wl-clipboard
    ./xdg
    ./niri
    ./eww
    ./mako
    ./swayidle
  ];

  options.desktop = {
    enable = lib.mkEnableOption "Enables graphical interface.";
  };

  config = lib.mkIf cfg.enable {
    xdg.enable = true;
  };
}
