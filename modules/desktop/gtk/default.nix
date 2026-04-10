{
  config,
  lib,
  pkgs,
  ...
}:

# GTK - GTK3/GTK4 theme configuration (Nightfox dark theme)
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
    };
    gtk.gtk4.theme = config.gtk.theme;
  };
}
