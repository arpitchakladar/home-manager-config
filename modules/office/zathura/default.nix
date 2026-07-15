{
  config,
  lib,
  pkgs,
  ...
}:

# Zathura - Minimalistic document viewer (PDF, DJVU, etc.)
{
  options.office.zathura = {
    enable = lib.mkEnableOption "Enables zathura.";
  };

  config = lib.mkIf config.office.zathura.enable {
    programs.zathura = {
      enable = true;
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
