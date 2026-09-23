# Screen recording utility for wlroots Wayland compositors
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.media.wf-recorder;
in
{
  options.media.wf-recorder = {
    enable = lib.mkEnableOption "Enables wf-recorder.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.wf-recorder;
      description = "The wf-recorder package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
