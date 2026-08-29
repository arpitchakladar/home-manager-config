# Screen recording utility for wlroots Wayland compositors
{
  config,
  pkgs,
  lib,
  ...
}:
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

  config = lib.mkIf config.media.wf-recorder.enable {
    home.packages = [ config.media.wf-recorder.package ];
  };
}
