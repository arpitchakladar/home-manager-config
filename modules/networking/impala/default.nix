# TUI for managing wifi on Linux
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networking.impala;
in
{
  imports = [
    ./assertions.nix
  ];

  options.networking.impala = {
    enable = lib.mkEnableOption "Enables impala.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.impala;
      description = "The impala package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".local/share/icons/hicolor/scalable/apps/network-wireless.svg" = {
      source = ../../../assets/icons/apps/network-wireless.svg;
    };

    xdg.desktopEntries."impala" = {
      name = "impala";
      exec = "${lib.getExe config.terminal.kitty.package} -e ${lib.getExe cfg.package}";
      icon = "network-wireless";
      categories = [ "Network" ];
      comment = "TUI for managing wifi on Linux";
      terminal = false;
      type = "Application";
    };
    home.packages = [
      cfg.package
    ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/impala" = "impala.desktop";
    };
  };
}
