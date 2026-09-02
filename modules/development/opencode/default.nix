# AI-powered coding assistant
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.development.opencode = {
    enable = lib.mkEnableOption "Enables opencode.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.opencode.package;
      description = "The opencode package to use.";
    };
  };

  config = lib.mkIf config.development.opencode.enable {
    home.file.".local/share/icons/hicolor/scalable/apps/opencode.svg" =
      lib.mkIf config.development.opencode.enable
        {
          source = ../../../assets/icons/apps/opencode.svg;
        };

    xdg.desktopEntries."opencode" = {
      name = "opencode";
      exec = "${lib.getExe config.terminal.kitty.package} --class opencode -e ${lib.getExe config.development.opencode.package}";
      icon = "opencode";
      categories = [ "Development" ];
      comment = "AI-powered coding assistant";
      terminal = false;
      type = "Application";
    };

    programs.opencode = {
      enable = true;
      package = pkgs.opencode;
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/opencode" = "opencode.desktop";
    };
  };
}
