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
    package = lib.mkPackageOption pkgs "vlc" { };
  };

  config = lib.mkIf config.programs.vlc.enable {
    home.packages = [ config.programs.vlc.package ];
  };
}
