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
