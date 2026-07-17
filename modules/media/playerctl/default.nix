# Playerctl - CLI for controlling media players (Spotify, MPRIS, etc.)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.media.playerctl = {
    enable = lib.mkEnableOption "Enables playerctl.";
    package = lib.mkPackageOption pkgs "playerctl" { };
  };

  config = lib.mkIf config.media.playerctl.enable {
    home.packages = [ config.media.playerctl.package ];
  };
}
