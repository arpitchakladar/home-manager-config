# Screen recording script using wf-recorder and slurp
{
  config,
  lib,
  pkgs,
  ...
}:
let
  screenRecordingScript = pkgs.writeShellApplication {
    name = "screen-recording";
    runtimeInputs = [
      pkgs.bash
      config.media.slurp.package
      config.media.wf-recorder.package
    ];
    text = builtins.readFile ./screen-recording.sh;
  };

  screenRecordingCompletion =
    pkgs.runCommand "screen-recording-completion"
      {
        nativeBuildInputs = [ pkgs.installShellFiles ];
      }
      ''
        mkdir -p $out/share/zsh/site-functions
        installShellCompletion zsh --name _screen-recording ${pkgs.writeText "screen-recording.zsh" (builtins.readFile ./screen-recording.zsh)}
      '';

  scriptPkg = pkgs.symlinkJoin {
    name = "screen-recording";
    paths = [
      screenRecordingScript
      screenRecordingCompletion
    ];
    meta = screenRecordingScript.meta or { };
  };
in
{
  options.media.screen-recording = {
    enable = lib.mkEnableOption "Screen recording script using wf-recorder and slurp";

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = scriptPkg;
      description = "The screen-recording script package.";
    };
  };

  config = lib.mkIf config.media.screen-recording.enable {
    home.packages = [ scriptPkg ];

    assertions = import ./assertions.nix { inherit config lib; };

    home.file.".local/share/icons/hicolor/scalable/apps/obs.svg" = {
      source = ../../../assets/icons/apps/obs.svg;
    };

    xdg.desktopEntries.screen-recording = {
      name = "Screen Recording";
      exec = "${lib.getExe config.terminal.kitty.package} --class screen-recording -e ${lib.getExe scriptPkg}";
      icon = "obs";
      categories = [ "Utility" ];
      terminal = false;
      type = "Application";
    };
  };
}
