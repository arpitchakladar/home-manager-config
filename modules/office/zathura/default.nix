{
  config,
  lib,
  pkgs,
  ...
}:

# Zathura - Minimalistic document viewer (PDF, DJVU, etc.)
{
  config = lib.mkIf config.programs.zathura.enable {
    programs.zathura = {
      package = pkgs.zathura;
    };

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "zathura.desktop";
      "application/x-pdf" = "zathura.desktop";
      "image/vnd.djvu" = "zathura.desktop";
      "application/epub+zip" = "zathura.desktop";
      "application/postscript" = "zathura.desktop";
      "application/vnd.comicbook+zip" = "zathura.desktop";
      "application/vnd.comicbook-rar" = "zathura.desktop";
    };
  };
}
