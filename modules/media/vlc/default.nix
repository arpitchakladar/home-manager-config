# Versatile multimedia player for audio and video playback
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.media.vlc = {
    enable = lib.mkEnableOption "Enables vlc.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.vlc;
      description = "The vlc package to use.";
    };
  };

  config = lib.mkIf config.media.vlc.enable {
    home.packages = [ config.media.vlc.package ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/vlc" = "vlc.desktop";
      "video/mp4" = "vlc.desktop";
      "video/mpeg" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "video/x-msvideo" = "vlc.desktop";
      "video/quicktime" = "vlc.desktop";
      "video/webm" = "vlc.desktop";
      "video/x-ms-wmv" = "vlc.desktop";
      "video/x-flv" = "vlc.desktop";
      "video/ogg" = "vlc.desktop";
      "audio/mpeg" = "vlc.desktop";
      "audio/ogg" = "vlc.desktop";
      "audio/x-wav" = "vlc.desktop";
      "audio/x-flac" = "vlc.desktop";
      "audio/mp4" = "vlc.desktop";
      "audio/x-matroska" = "vlc.desktop";
    };
  };
}
