{
  config,
  lib,
  pkgs,
  ...
}:

# Slop - Region selector for screenshots (used by maim/flameshot)
{
  options.programs.slop = {
    enable = lib.mkEnableOption "Enables slop.";
    package = lib.mkPackageOption pkgs "slop" { };
  };

  config = lib.mkIf config.programs.slop.enable {
    home.packages = [ config.programs.slop.package ];
  };
}
