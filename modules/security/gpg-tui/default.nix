# Terminal UI for GnuPG
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.security.gpg-tui = {
    enable = lib.mkEnableOption "Enables gpg-tui.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.gpg-tui;
      description = "The gpg-tui package to use.";
    };
  };

  config = lib.mkIf config.security.gpg-tui.enable {
    home.file.".local/share/icons/hicolor/scalable/apps/gpg.svg" = {
      source = ../../../assets/icons/apps/gpg.svg;
    };

    xdg.desktopEntries."gpg-tui" = {
      name = "gpg-tui";
      exec = "${lib.getExe config.terminal.kitty.package} --class gpg-tui -e ${lib.getExe config.security.gpg-tui.package}";
      icon = "gpg";
      categories = [ "Security" ];
      comment = "Terminal UI for GnuPG";
      terminal = false;
      type = "Application";
    };

    home.packages = [ config.security.gpg-tui.package ];
  };
}
