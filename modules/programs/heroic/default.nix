{
  config,
  pkgs,
  lib,
  ...
}:

# Heroic Games Launcher - An elegant UI for Epic, GOG, and Amazon Games using UMU under the hood
{
  imports = [
    ./nexus-mods.nix
    ./steam.nix
  ];

  options.programs.heroic = {
    enable = lib.mkEnableOption "Enables Heroic Games Launcher.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.symlinkJoin {
        name = "heroic-bundle";
        paths = with pkgs; [
          # Wrap Heroic so it dynamically appends gamemode's library folder to LD_LIBRARY_PATH
          (pkgs.symlinkJoin {
            name = "heroic-wrapped";
            paths = [ heroic ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/heroic \
                --prefix LD_LIBRARY_PATH : "${pkgs.gamemode.lib}/lib:${pkgs.pkgsi686Linux.gamemode.lib}/lib"
            '';
          })
          winetricks
          xdg-user-dirs
          gamemode
        ];
      };
      description = "Bundle of Heroic Games Launcher, winetricks, and core utilities with GameMode support.";
    };
  };

  config = lib.mkIf config.programs.heroic.enable {
    home.packages = [ config.programs.heroic.package ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/heroic" = "heroic.desktop";
    };
  };
}
