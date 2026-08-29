# Open-source API client for testing HTTP endpoints
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.development.bruno = {
    enable = lib.mkEnableOption "Enables bruno.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.bruno;
      description = "The bruno package to use.";
    };
  };

  config = lib.mkIf config.development.bruno.enable {
    home.packages = [ config.development.bruno.package ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/bruno" = "bruno.desktop";
    };
  };
}
