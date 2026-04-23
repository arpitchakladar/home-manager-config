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
  };

  config = lib.mkIf config.programs.ffmpeg.enable {
    home.packages = with pkgs; [
      ffmpeg-full
    ];
  };
}
