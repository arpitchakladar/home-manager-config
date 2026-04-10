{
  config,
  lib,
  pkgs,
  ...
}:

# Impala - Apache Impala: SQL query engine for Apache Hadoop
{
  options.tools.impala = {
    enable = lib.mkEnableOption "Enables impala.";
  };

  config = lib.mkIf config.tools.impala.enable {
    home.packages = with pkgs; [
      impala
    ];
  };
}
