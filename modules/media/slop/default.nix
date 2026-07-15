{
  config,
  lib,
  pkgs,
  ...
}:

# Slop - Region selector for screenshots (used by maim/flameshot)
{
  options.media.slop = {
    enable = lib.mkEnableOption "Enables slop.";
    package = lib.mkPackageOption pkgs "slop" { };
  };

  config = lib.mkIf config.media.slop.enable {
    home.packages = [ config.media.slop.package ];
  };
}
