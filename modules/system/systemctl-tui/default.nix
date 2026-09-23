# TUI for systemctl
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.system.systemctl-tui;
in
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

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.file.".local/share/icons/hicolor/scalable/apps/systemd.svg" = {
        source = ../../../assets/icons/apps/systemd.svg;
      };

      home.packages = [ cfg.package ];
    })
    (lib.mkIf (cfg.enable && config.terminal.kitty.enable) {
      xdg.desktopEntries."systemctl-tui" = {
        name = "systemctl-tui";
        exec = "${lib.getExe config.terminal.kitty.package} --class systemctl-tui -e ${lib.getExe cfg.package}";
        icon = "systemd";
        categories = [ "System" ];
        comment = "TUI for systemctl";
        terminal = false;
        type = "Application";
      };
    })
  ];
}
