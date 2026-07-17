# Feh - Lightweight image viewer and wallpaper setter
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.media.feh = {
    enable = lib.mkEnableOption "Enables feh.";
  };

  config = lib.mkIf config.media.feh.enable {
    programs.feh = {
      enable = true;
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
