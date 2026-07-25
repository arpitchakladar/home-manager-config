# Impala - TUI for managing wifi on Linux
{
  config,
  lib,
  pkgs,
  ...
}:
let
  impalaDesktopItem = pkgs.makeDesktopItem {
    name = "impala";
    desktopName = "Impala";
    exec = "${lib.getExe config.terminal.kitty.package} --class impala -e ${lib.getExe config.networking.impala.package}";
    icon = "kitty";
    categories = [ "Network" ];
    comment = "TUI for managing wifi on Linux";
    terminal = false;
    type = "Application";
  };
in
{
  imports = [
    ./assertions.nix
  ];

  options.networking.impala = {
    enable = lib.mkEnableOption "Enables impala.";
    package = lib.mkPackageOption pkgs "impala" { };
  };

  config = lib.mkIf config.networking.impala.enable {
    home.packages = [
      config.networking.impala.package
      impalaDesktopItem
    ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/impala" = "impala.desktop";
    };
  };
}
