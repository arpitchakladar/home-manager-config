# Bluetooth TUI client
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
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.bluetui;
      description = "The bluetui package to use.";
    };
  };

  config = lib.mkIf config.networking.bluetui.enable {
    home.file.".local/share/icons/hicolor/scalable/apps/bluetooth.svg" = {
      source = ../../../assets/icons/apps/bluetooth.svg;
    };

    xdg.desktopEntries."bluetui" = {
      name = "bluetui";
      exec = "${lib.getExe config.terminal.kitty.package} -e ${lib.getExe config.networking.bluetui.package}";
      icon = "bluetooth";
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
