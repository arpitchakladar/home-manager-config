# Bluetui - Bluetooth TUI client
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.networking.bluetui = {
    enable = lib.mkEnableOption "Enables bluetui.";
    package = lib.mkPackageOption pkgs "bluetui" { };
  };

  config = lib.mkIf config.networking.bluetui.enable {
    home.packages = [ config.networking.bluetui.package ];
  };
}
