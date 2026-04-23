{
  config,
  lib,
  pkgs,
  ...
}:

# Impala - Apache Impala: SQL query engine for Apache Hadoop
{
  options.programs.impala = {
    enable = lib.mkEnableOption "Enables impala.";
  };

  config = lib.mkIf config.programs.impala.enable {
    home.packages = with pkgs; [
      impala
    ];
  };
}
