# AI-powered coding assistant
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development.opencode;
in
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

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.file.".local/share/icons/hicolor/scalable/apps/opencode.svg" = {
        source = ../../../assets/icons/apps/opencode.svg;
      };

      programs.opencode = {
        enable = true;
        package = pkgs.opencode;
      };
    })
    (lib.mkIf (cfg.enable && config.terminal.kitty.enable) {
      xdg.desktopEntries."opencode" = {
        name = "opencode";
        exec = "${lib.getExe config.terminal.kitty.package} --class opencode -e ${lib.getExe cfg.package}";
        icon = "opencode";
        categories = [ "Development" ];
        comment = "AI-powered coding assistant";
        terminal = false;
        type = "Application";
      };

      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/opencode" = "opencode.desktop";
      };
    })
  ];
}
