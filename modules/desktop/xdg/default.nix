# XDG Desktop Portal configuration
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.desktop.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-termfilechooser
        xdg-desktop-portal-hyprland
      ];
      config.common = {
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        default = [ "hyprland" ];
      };
      xdgOpenUsePortal = true;
    };

    home.sessionVariables = {
      TERMCMD = lib.mkIf config.terminal.kitty.enable "${lib.getExe config.terminal.kitty.package} --class file-explorer --title 'Yazi'";
    };
  };
}
