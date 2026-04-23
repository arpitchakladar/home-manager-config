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
  };

  config = lib.mkIf config.programs.playerctl.enable {
    home.packages = with pkgs; [
      playerctl
    ];
  };
}
