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
    home.packages = [ config.system.systemctl-tui.package ];
  };
}
