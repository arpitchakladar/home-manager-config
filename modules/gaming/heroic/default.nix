# Epic, GOG and Amazon game launcher
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming.heroic;
  icons = config.desktop.icons.apps;
in
{
  options.gaming.heroic = {
    enable = lib.mkEnableOption "Enables Heroic Games Launcher.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.symlinkJoin {
        name = "heroic-wrapped";
        paths = [
          pkgs.winetricks
          pkgs.xdg-user-dirs
          pkgs.gamemode
          pkgs.heroic
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

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file.".local/share/icons/hicolor/scalable/apps/com.heroicgameslauncher.hgl.svg".source =
      "${pkgs.heroic}/share/icons/hicolor/scalable/apps/com.heroicgameslauncher.hgl.svg";

    xdg.desktopEntries."heroic" = {
      name = "Heroic Games Launcher";
      exec = "${lib.getExe' cfg.package "heroic"} %u";
      icon = icons.heroic;
      comment = "An Open Source Launcher for GOG, Epic Games and Amazon Games";
      categories = [ "Game" ];
      mimeType = [ "x-scheme-handler/heroic" ];
      type = "Application";
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/heroic" = "heroic.desktop";
    };
  };
}
