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
    description = "Screen recording script using wf-recorder and slurp for region selection\nRecords Wayland screen to MP4\nUsage: screen-recording.sh [-s|--select]\n  -s, --select  Launch slurp to select recording region";
    deps = [
      config.media.slurp.package
      config.media.wf-recorder.package
    ];
    desktop = {
      enable = true;
      displayName = "Screen Recording";
      icon = "obs";
    };
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig // {
    assertions = base.moduleConfig.assertions ++ (import ./assertions.nix { inherit config lib; });
    home.file.".local/share/icons/hicolor/scalable/apps/obs.svg" = {
      source = ../../../assets/icons/obs.svg;
    };
  };
}
