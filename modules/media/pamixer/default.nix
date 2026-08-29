# PulseAudio command-line mixer
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.media.pamixer = {
    enable = lib.mkEnableOption "Enables pamixer.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.pamixer;
      description = "The pamixer package to use.";
    };
  };

  config = lib.mkIf config.media.pamixer.enable {
    home.packages = [ config.media.pamixer.package ];
  };
}
