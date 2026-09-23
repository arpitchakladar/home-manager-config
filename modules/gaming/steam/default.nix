# Game store
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming.steam;
in
{
  options.gaming.steam = {
    enable = lib.mkEnableOption "Enables steam.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.steam;
      description = "Package for steam app.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
