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
    package = lib.mkPackageOption pkgs "systemctl-tui" { };
  };

  config = lib.mkIf config.system.systemctl-tui.enable {
    home.packages = [ config.system.systemctl-tui.package ];
  };
}
