{
  config,
  lib,
  pkgs,
  ...
}:

# Bluetui - Terminal UI for Bluetooth management
{
  options.programs.bluetui = {
    enable = lib.mkEnableOption "Enables bluetui.";
    package = lib.mkPackageOption pkgs "bluetui" { };
  };

  config = lib.mkIf config.programs.bluetui.enable {
    home.packages = [ config.programs.bluetui.package ];
  };
}
