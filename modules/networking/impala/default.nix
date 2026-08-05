# TUI for managing wifi on Linux
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

  options.networking.impala = {
    enable = lib.mkEnableOption "Enables impala.";
    package = lib.mkPackageOption pkgs "impala" { };
  };

  config = lib.mkIf config.networking.impala.enable {
    home.file.".local/share/icons/hicolor/scalable/apps/network-wireless.svg" = {
      source = ../../../assets/icons/network-wireless.svg;
    };

    xdg.desktopEntries."impala" = {
      name = "impala";
      exec = "${lib.getExe config.terminal.kitty.package} -e ${lib.getExe config.networking.impala.package}";
      icon = "network-wireless";
      categories = [ "Network" ];
      comment = "TUI for managing wifi on Linux";
      terminal = false;
      type = "Application";
    };
    home.packages = [
      config.networking.impala.package
    ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/impala" = "impala.desktop";
    };
  };
}
