{
  config,
  pkgs,
  lib,
  ...
}:

# systemctl-tui - TUI for systemctl (systemd service management)
{
  options.system.systemctl-tui = {
    enable = lib.mkEnableOption "Enables systemctl-tui.";
    package = lib.mkPackageOption pkgs "systemctl-tui" { };
  };

  config = lib.mkIf config.system.systemctl-tui.enable {
    home.packages = [ config.system.systemctl-tui.package ];
  };
}
