{
  config,
  pkgs,
  lib,
  ...
}:

# FFmpeg - Command-line audio/video converter and streaming tool
{
  options.media.ffmpeg = {
    enable = lib.mkEnableOption "Enables ffmpeg.";
    package = lib.mkPackageOption pkgs "ffmpeg-full" { };
  };

  config = lib.mkIf config.media.ffmpeg.enable {
    home.packages = [ config.media.ffmpeg.package ];
  };
}
