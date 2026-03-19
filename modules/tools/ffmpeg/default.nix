{
  config,
  pkgs,
  lib,
  ...
}:

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
