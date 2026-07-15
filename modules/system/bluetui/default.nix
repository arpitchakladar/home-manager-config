{
  config,
  lib,
  pkgs,
  ...
}:

# Bluetui - Terminal UI for Bluetooth management
{
  options.system.bluetui = {
    enable = lib.mkEnableOption "Enables bluetui.";
    package = lib.mkPackageOption pkgs "bluetui" { };
  };

  config = lib.mkIf config.system.bluetui.enable {
    home.packages = [ config.system.bluetui.package ];
  };
}
