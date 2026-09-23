# Open-source API client for testing HTTP endpoints
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development.bruno;
in
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

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/bruno" = "bruno.desktop";
    };
  };
}
