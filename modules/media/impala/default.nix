{
  config,
  lib,
  pkgs,
  ...
}:

# Impala - Apache Impala: SQL query engine for Apache Hadoop
{
  options.media.impala = {
    enable = lib.mkEnableOption "Enables impala.";
    package = lib.mkPackageOption pkgs "impala" { };
  };

  config = lib.mkIf config.media.impala.enable {
    home.packages = [ config.media.impala.package ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/impala" = "impala.desktop";
      "audio/mpeg" = "impala.desktop";
      "audio/ogg" = "impala.desktop";
      "audio/flac" = "impala.desktop";
      "audio/x-flac" = "impala.desktop";
    };
  };
}
