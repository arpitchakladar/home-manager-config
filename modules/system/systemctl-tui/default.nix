# TUI for systemctl
{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.system.systemctl-tui = {
    enable = lib.mkEnableOption "Enables systemctl-tui.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.systemctl-tui;
      description = "The systemctl-tui package to use.";
    };
  };

  config = lib.mkIf config.system.systemctl-tui.enable {
    home.file.".local/share/icons/hicolor/scalable/apps/systemd.svg" = {
      source = ../../../assets/icons/apps/systemd.svg;
    };

    xdg.desktopEntries."systemctl-tui" = {
      name = "systemctl-tui";
      exec = "${lib.getExe config.terminal.kitty.package} --class systemctl-tui -e ${lib.getExe config.system.systemctl-tui.package}";
      icon = "systemd";
      categories = [ "System" ];
      comment = "TUI for systemctl";
      terminal = false;
      type = "Application";
    };

    home.packages = [ config.system.systemctl-tui.package ];
  };
}
