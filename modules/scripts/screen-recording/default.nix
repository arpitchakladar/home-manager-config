{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "screen-recording";
    path = ./script.sh;
    description = "Screen recording script using FFmpeg and slop for region selection\nRecords X11 screen to MP4 with x264 encoding\nUsage: screen-recording.sh [-s|--select]\n  -s, --select  Launch slop to select recording region";
    deps = [
      config.media.ffmpeg.package
      config.media.slop.package
    ];
    desktop = {
      enable = true;
      displayName = "Screen Recording";
    };
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig // {
    assertions = base.moduleConfig.assertions ++ (import ./assertions.nix { inherit config lib; });
  };
}
