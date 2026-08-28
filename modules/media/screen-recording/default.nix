# Screen recording script using wf-recorder and slurp
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../../lib/script.nix { inherit lib pkgs; })) mkScriptModule;
  script = mkScriptModule {
    scope = [ "media" ];
    name = "screen-recording";
    path = ./screen-recording.sh;
    description = "Screen recording script using wf-recorder and slurp for region selection\nRecords Wayland screen to MP4\nUsage: screen-recording.sh [-s|--select]\n  -s, --select  Launch slurp to select recording region";
    deps = [
      pkgs.bash
      config.media.slurp.package
      config.media.wf-recorder.package
    ];
    completion.zsh = builtins.readFile ./screen-recording.zsh;
    desktop = {
      enable = true;
      displayName = "Screen Recording";
      icon = "obs";
    };
    inherit config;
  };
in
{
  options = script.options;
  config = lib.mkMerge [
    script.config
    {
      assertions = import ./assertions.nix { inherit config lib; };
      home.file.".local/share/icons/hicolor/scalable/apps/obs.svg" = {
        source = ../../../assets/icons/apps/obs.svg;
      };
    }
  ];
}
