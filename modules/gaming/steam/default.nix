# Game store
{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.gaming.steam = {
    enable = lib.mkEnableOption "Enables steam.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.steam;
      description = "Package for steam app.";
    };
  };

  config = lib.mkIf config.gaming.steam.enable {
    home.packages = [ config.gaming.steam.package ];
  };
}
