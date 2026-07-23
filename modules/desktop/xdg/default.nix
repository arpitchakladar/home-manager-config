# xdg - XDG Desktop Portal configuration
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
        xdg-desktop-portal-gtk
      ];
      config.common = {
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        default = [
          "gtk"
        ];
      };
      xdgOpenUsePortal = true;
    };

    home.sessionVariables = {
      GTK_USE_PORTAL = "1";
      TERMCMD = lib.mkIf config.terminal.kitty.enable (lib.getExe config.terminal.kitty.package);
    };
  };
}
