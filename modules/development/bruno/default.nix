{
  config,
  lib,
  pkgs,
  ...
}:

# Bruno - Open-source API client for testing HTTP endpoints
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
