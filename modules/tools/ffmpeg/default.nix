{
  config,
  pkgs,
  lib,
  ...
}:

# FFmpeg - Command-line audio/video converter and streaming tool
{
  options.tools.ffmpeg = {
    enable = lib.mkEnableOption "Enables ffmpeg.";
  };

  config = lib.mkIf config.tools.ffmpeg.enable {
    home.packages = with pkgs; [
      ffmpeg-full
    ];
  };
}
