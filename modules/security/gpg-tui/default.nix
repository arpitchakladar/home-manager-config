# Terminal UI for GnuPG
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.security.gpg-tui;
  icons = config.desktop.icons.apps;
in
{
  options.security.gpg-tui = {
    enable = lib.mkEnableOption "Enables gpg-tui.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.gpg-tui;
      description = "The gpg-tui package to use.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];
    })
    (lib.mkIf (cfg.enable && config.terminal.kitty.enable) {
      xdg.desktopEntries."gpg-tui" = {
        name = "gpg-tui";
        exec = "${lib.getExe config.terminal.kitty.package} --class gpg-tui -e ${lib.getExe cfg.package}";
        icon = icons.gpg;
        categories = [ "Security" ];
        comment = "Terminal UI for GnuPG";
        terminal = false;
        type = "Application";
      };
    })
  ];
}
