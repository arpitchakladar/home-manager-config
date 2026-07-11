{
  config,
  lib,
  pkgs,
  ...
}:

# Feh - Lightweight image viewer and wallpaper setter
{
  config = lib.mkIf config.programs.feh.enable {
    programs.feh = {
      package = pkgs.feh;
    };

    xdg.mimeApps.defaultApplications = {
      "image/bmp" = "feh.desktop";
      "image/gif" = "feh.desktop";
      "image/jpeg" = "feh.desktop";
      "image/png" = "feh.desktop";
      "image/tiff" = "feh.desktop";
      "image/webp" = "feh.desktop";
      "image/x-bmp" = "feh.desktop";
      "image/x-png" = "feh.desktop";
      "image/x-tga" = "feh.desktop";
    };
  };
}
