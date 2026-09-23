# CLI for controlling media players
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.media.playerctl;
in
{
  options.media.playerctl = {
    enable = lib.mkEnableOption "Enables playerctl.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.playerctl;
      description = "The playerctl package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
