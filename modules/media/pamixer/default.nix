# Pamixer - PulseAudio command-line mixer (volume control)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.media.pamixer = {
    enable = lib.mkEnableOption "Enables pamixer.";
    package = lib.mkPackageOption pkgs "pamixer" { };
  };

  config = lib.mkIf config.media.pamixer.enable {
    home.packages = [ config.media.pamixer.package ];
  };
}
