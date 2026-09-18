# XDG Desktop Portal configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  base16Colors = import ../../colors/base16 { inherit config lib pkgs; };
in
{
  config = lib.mkIf config.desktop.enable {
    dconf.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-termfilechooser
        pkgs.xdg-desktop-portal-gtk
      ];
      configPackages = [ pkgs.niri ];
      config.common = {
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        default = [ "gtk" ];
      };
      xdgOpenUsePortal = true;
    };

    gtk =
      let
        gtkColorSchemeCss = builtins.readFile (base16Colors {
          templateFileOrContent = builtins.readFile ./style.css;
          fileExtension = ".css";
        });
      in
      {
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
        gtk3.extraCss = gtkColorSchemeCss;
        gtk4 = {
          # GTK 4/libadwaita does not support loading GTK 3 themes; use the
          # themed CSS above without Home Manager's compatibility workaround.
          theme = null;
          extraCss = gtkColorSchemeCss;
        };
      };
  };
}
