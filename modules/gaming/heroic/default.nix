# Heroic Games Launcher - Epic/GOG/Amazon game launcher
{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.gaming.heroic = {
    enable = lib.mkEnableOption "Enables Heroic Games Launcher.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.symlinkJoin {
        name = "heroic-wrapped";
        paths = with pkgs; [
          winetricks
          xdg-user-dirs
          gamemode
          heroic
        ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/heroic \
            --prefix LD_LIBRARY_PATH : "${pkgs.gamemode.lib}/lib:${pkgs.pkgsi686Linux.gamemode.lib}/lib"
        '';
      };
      description = "Heroic Games Launcher package (wrapped with GameMode support).";
    };
  };

  config = lib.mkIf config.gaming.heroic.enable {
    home.packages = [ config.gaming.heroic.package ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/heroic" = "heroic.desktop";
    };
  };
}
