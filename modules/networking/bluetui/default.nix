# Bluetui - Bluetooth TUI client
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./assertions.nix
  ];

  options.networking.bluetui = {
    enable = lib.mkEnableOption "Enables bluetui.";
    package = lib.mkPackageOption pkgs "bluetui" { };
  };

  config = lib.mkIf config.networking.bluetui.enable {
    xdg.desktopEntries."bluetui" = {
      name = "bluetui";
      exec = "${lib.getExe config.terminal.kitty.package} -e ${lib.getExe config.networking.bluetui.package}";
      icon = "kitty";
      categories = [ "Network" ];
      comment = "Bluetooth TUI client";
      terminal = false;
      type = "Application";
    };
    home.packages = [
      config.networking.bluetui.package
    ];
  };
}
