# CLI for controlling media players
{
  config,
  lib,
  pkgs,
  ...
}:
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

  config = lib.mkIf config.media.playerctl.enable {
    home.packages = [ config.media.playerctl.package ];
  };
}
