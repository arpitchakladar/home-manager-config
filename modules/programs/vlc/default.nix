{
  config,
  lib,
  pkgs,
  ...
}:

# VLC - Versatile multimedia player for audio/video playback
{
  options.programs.vlc = {
    enable = lib.mkEnableOption "Enables vlc.";
  };

  config = lib.mkIf config.programs.vlc.enable {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
