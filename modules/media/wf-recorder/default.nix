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
    package = lib.mkPackageOption pkgs "wf-recorder" { };
  };

  config = lib.mkIf config.media.wf-recorder.enable {
    home.packages = [ config.media.wf-recorder.package ];
  };
}
