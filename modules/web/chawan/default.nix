# Text-based web browser and pager
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.web.chawan;
in
{
  imports = [
    ./assertions.nix
  ];

  options.web.chawan = {
    enable = lib.mkEnableOption "Enables chawan.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.chawan.package;
      description = "Package to use for chawan.";
    };
    home-url = lib.mkOption {
      type = lib.types.str;
      default = "https://searx.space";
      description = "The first page to open when chawan is launched.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.file.".local/share/icons/hicolor/scalable/apps/internet-web-browser.svg" = {
        source = ../../../assets/icons/apps/internet-web-browser.svg;
      };

      programs.chawan = {
        enable = true;
        settings = {
          buffer = {
            images = true;
            user-style = builtins.readFile ./user-style.css;
          };
          display = {
            image-mode = "auto";
            set-title = false;
          };
          network = {
            allow-http-from-file = true;
          };
          page = {
            o = ''() => pager.extern('xdg-open "$CHA_HOVER_URL"', {env: {CHA_HOVER_URL: pager.hoverLink}})'';
          };
        };
      };
      home.packages = [
        cfg.package
      ];
    })
    (lib.mkIf (cfg.enable && config.terminal.kitty.enable) {
      xdg.desktopEntries."chawan" = {
        name = "Chawan";
        exec = "${lib.getExe config.terminal.kitty.package} --class chawan -e ${lib.getExe cfg.package} ${cfg.home-url}";
        icon = "internet-web-browser";
        categories = [ "Network" ];
        comment = "Text-based web browser";
        terminal = false;
        type = "Application";
      };
    })
  ];
}
