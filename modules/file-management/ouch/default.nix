# Ouch! - CLI tool for compressing and decompressing various formats.
{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.file-management.ouch = {
    enable = lib.mkEnableOption "Enables ouch.";
    package = lib.mkPackageOption pkgs "ouch" { };
  };

  config = lib.mkIf config.file-management.ouch.enable {
    home.packages = [ config.file-management.ouch.package ];
  };
}
