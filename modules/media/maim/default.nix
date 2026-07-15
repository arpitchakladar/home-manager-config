{
  config,
  lib,
  pkgs,
  ...
}:

# Maim - Screenshot utility (slop-based region selection)
{
  options.media.maim = {
    enable = lib.mkEnableOption "Enables maim.";
    package = lib.mkPackageOption pkgs "maim" { };
  };

  config = lib.mkIf config.media.maim.enable {
    home.packages = [ config.media.maim.package ];
  };
}
