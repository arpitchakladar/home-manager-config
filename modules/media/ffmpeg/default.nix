{
  config,
  pkgs,
  lib,
  ...
}:

# FFmpeg - Command-line audio/video converter and streaming tool
{
  options.programs.ffmpeg = {
    enable = lib.mkEnableOption "Enables ffmpeg.";
    package = lib.mkPackageOption pkgs "ffmpeg-full" { };
  };

  config = lib.mkIf config.programs.ffmpeg.enable {
    home.packages = [ config.programs.ffmpeg.package ];
  };
}
