{
  config,
  pkgs,
  lib,
  ...
}:

# Steam - game store
{
  options.programs.heroic.steam = {
    enable = lib.mkEnableOption "Enables steam.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.steam;
      description = "Package for steam app.";
    };
  };

  config = lib.mkIf config.programs.heroic.steam.enable {
    home.packages = [ config.programs.heroic.steam.package ];
  };
}
