# Bluetooth TUI client
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networking.bluetui;
  icons = config.desktop.icons.apps;
in
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

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries."bluetui" = {
      name = "bluetui";
      exec = "${lib.getExe config.terminal.kitty.package} -e ${lib.getExe cfg.package}";
      icon = icons.bluetui;
      categories = [ "Network" ];
      comment = "Bluetooth TUI client";
      terminal = false;
      type = "Application";
    };
    home.packages = [
      cfg.package
    ];
  };
}
