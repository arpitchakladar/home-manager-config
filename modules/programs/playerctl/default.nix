{
  config,
  lib,
  pkgs,
  ...
}:

# Playerctl - CLI for controlling media players (Spotify, MPRIS, etc.)
{
  options.programs.playerctl = {
    enable = lib.mkEnableOption "Enables playerctl.";
    package = lib.mkPackageOption pkgs "playerctl" { };
  };

  config = lib.mkIf config.programs.playerctl.enable {
    home.packages = [ config.programs.playerctl.package ];
  };
}
