# Bruno - Open-source API client for testing HTTP endpoints
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.development.bruno = {
    enable = lib.mkEnableOption "Enables bruno.";
    package = lib.mkPackageOption pkgs "bruno" { };
  };

  config = lib.mkIf config.development.bruno.enable {
    home.packages = [ config.development.bruno.package ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/bruno" = "bruno.desktop";
    };
  };
}
