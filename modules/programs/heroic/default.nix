{
  config,
  pkgs,
  lib,
  ...
}:

# Heroic Games Launcher - An elegant UI for Epic, GOG, and Amazon Games using UMU under the hood
{
  options.programs.heroic = {
    enable = lib.mkEnableOption "Enables Heroic Games Launcher.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.symlinkJoin {
        name = "heroic-bundle";
        paths = with pkgs; [
          heroic
          winetricks
          xdg-user-dirs
        ];
      };
      description = "Bundle of Heroic Games Launcher, winetricks, and core utilities.";
    };
  };

  config = lib.mkIf config.programs.heroic.enable {
    home.packages = [ config.programs.heroic.package ];
  };
}
