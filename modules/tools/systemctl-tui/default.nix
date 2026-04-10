{
  config,
  pkgs,
  lib,
  ...
}:

# systemctl-tui - TUI for systemctl (systemd service management)
{
  options.tools.systemctl-tui = {
    enable = lib.mkEnableOption "Enables systemctl-tui.";
  };

  config = lib.mkIf config.tools.systemctl-tui.enable {
    home.packages = with pkgs; [
      systemctl-tui
    ];
  };
}
