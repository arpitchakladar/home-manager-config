{
  config,
  lib,
  pkgs,
  ...
}:

# Playerctl - CLI for controlling media players (Spotify, MPRIS, etc.)
{
  options.tools.playerctl = {
    enable = lib.mkEnableOption "Enables playerctl.";
  };

  config = lib.mkIf config.tools.playerctl.enable {
    home.packages = with pkgs; [
      playerctl
    ];
  };
}
