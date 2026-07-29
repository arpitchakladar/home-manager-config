# GTK - GTK3/GTK4 theme configuration (Nightfox dark theme)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.desktop.enable {
    gtk = {
      enable = true;
      colorScheme = "dark";
      theme = {
        package = pkgs.nightfox-gtk-theme.override {
          tweakVariants = [ "carbonfox" ];
        };
        name = "Nightfox-Dark-Carbonfox";
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    gtk.gtk4.theme = config.gtk.theme;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Nightfox-Dark-Carbonfox";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk4";
      style.name = "adwaita-dark";
    };
  };
}
