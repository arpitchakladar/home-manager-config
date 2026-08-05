# Minimalistic document viewer
{
  config,
  lib,
  ...
}:
{
  options.office.zathura = {
    enable = lib.mkEnableOption "Enables zathura.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.zathura.package;
      description = "The zathura package to use.";
    };
  };

  config = lib.mkIf config.office.zathura.enable {
    programs.zathura = {
      enable = true;
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
