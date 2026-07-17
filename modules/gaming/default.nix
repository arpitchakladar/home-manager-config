# Gaming - Collection of game launchers and gaming utilities
{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./steam.nix
  ];

  options.gaming = {
    enable = lib.mkEnableOption "gaming tools bundle (Heroic, winetricks, gamemode).";
    launcher = lib.mkOption {
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
      description = "Bundle of game launchers (Heroic), winetricks, and core gaming utilities with GameMode support.";
    };
  };

  config = lib.mkIf config.gaming.enable {
    home.packages = [ config.gaming.launcher ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/heroic" = "heroic.desktop";
    };
  };
}
