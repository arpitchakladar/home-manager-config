{
  config,
  pkgs,
  lib,
  ...
}:

# Nexus Mods - for Modding Games
{
  options.programs.heroic.nexus-mods = {
    enable = lib.mkEnableOption "Enables NexusMods.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nexusmods-app-unfree;
      description = "Package for NexusMods app, used to mod games.";
    };
  };

  config = lib.mkIf config.programs.heroic.enable {
    home.packages = [ config.programs.heroic.nexus-mods.package ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/nxm" = [ "nexusmods-app.desktop" ];
      };
    };

    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "nexusmods-app-unfree-0.21.1"
      ];
    };
  };
}
