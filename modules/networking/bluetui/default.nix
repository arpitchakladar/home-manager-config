# Bluetui - Bluetooth TUI client
{
  config,
  lib,
  pkgs,
  ...
}:
let
  bluetuiDesktopItem = pkgs.makeDesktopItem {
    name = "bluetui";
    desktopName = "BlueTUI";
    exec = "${lib.getExe config.terminal.kitty.package} --class bluetui -e ${lib.getExe config.networking.bluetui.package}";
    icon = "kitty";
    categories = [ "Network" ];
    comment = "Bluetooth TUI client";
    terminal = false;
    type = "Application";
  };
in
{
  imports = [
    ./assertions.nix
  ];

  options.networking.bluetui = {
    enable = lib.mkEnableOption "Enables bluetui.";
    package = lib.mkPackageOption pkgs "bluetui" { };
  };

  config = lib.mkIf config.networking.bluetui.enable {
    home.packages = [
      config.networking.bluetui.package
      bluetuiDesktopItem
    ];
  };
}
