# XDG Desktop Portal configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  gtkCss = builtins.readFile (
    config.scheme {
      template = builtins.readFile ./style.mustache.css;
      extension = ".css";
    }
  );
in
{
  config = lib.mkIf config.desktop.enable {
    dconf.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-termfilechooser
        xdg-desktop-portal-gtk
      ];
      configPackages = [ pkgs.niri ];
      config.common = {
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        default = [ "gtk" ];
      };
      xdgOpenUsePortal = true;
    };

    gtk = {
      enable = true;
      font = {
        name = config.fonts.normal;
        size = config.fonts.uiSize;
      };
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 20;
      };
      colorScheme = "dark";
      gtk3.extraCss = gtkCss;
      gtk4 = {
        # GTK 4/libadwaita does not support loading GTK 3 themes; use the
        # Base16 CSS above without Home Manager's compatibility workaround.
        theme = null;
        extraCss = gtkCss;
      };
    };
  };
}
