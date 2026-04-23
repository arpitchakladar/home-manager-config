{
  config,
  lib,
  pkgs,
  ...
}:

# Maim - Screenshot utility (slop-based region selection)
{
  options.programs.maim = {
    enable = lib.mkEnableOption "Enables maim.";
    package = lib.mkPackageOption pkgs "maim" { };
  };

  config = lib.mkIf config.programs.maim.enable {
    home.packages = [ config.programs.maim.package ];
  };
}
