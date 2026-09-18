# Text-based web browser and pager
{
  config,
  lib,
  ...
}:
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
    homeUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://searx.space";
      description = "The first page to open when chawan is launched.";
    };
  };

  config = lib.mkIf config.web.chawan.enable {
    home.file.".local/share/icons/hicolor/scalable/apps/internet-web-browser.svg" = {
      source = ../../../assets/icons/apps/internet-web-browser.svg;
    };

    xdg.desktopEntries."chawan" = {
      name = "Chawan";
      exec = "${lib.getExe config.terminal.kitty.package} --class chawan -e ${lib.getExe config.web.chawan.package} ${config.web.chawan.homeUrl}";
      icon = "internet-web-browser";
      categories = [ "Network" ];
      comment = "Text-based web browser";
      terminal = false;
      type = "Application";
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
      config.web.chawan.package
    ];
  };
}
