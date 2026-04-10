{
  config,
  lib,
  pkgs,
  ...
}:

# VLC - Versatile multimedia player for audio/video playback
{
  options.tools.vlc = {
    enable = lib.mkEnableOption "Enables vlc.";
  };

  config = lib.mkIf config.tools.vlc.enable {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
