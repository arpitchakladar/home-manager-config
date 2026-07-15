{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.networking.impala = {
    enable = lib.mkEnableOption "Enables impala.";
    package = lib.mkPackageOption pkgs "impala" { };
  };

  config = lib.mkIf config.networking.impala.enable {
    home.packages = [ config.networking.impala.package ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/impala" = "impala.desktop";
    };
  };
}
