# PulseAudio command-line mixer
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.media.pamixer;
in
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

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
