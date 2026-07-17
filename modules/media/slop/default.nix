# Slop - Region selector for screenshots (used by maim/flameshot)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.media.slop = {
    enable = lib.mkEnableOption "Enables slop.";
    package = lib.mkPackageOption pkgs "slop" { };
  };

  config = lib.mkIf config.media.slop.enable {
    home.packages = [ config.media.slop.package ];
  };
}
