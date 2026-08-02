# gopass - Standard Unix password manager (Go implementation)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.security.gopass = {
    enable = lib.mkEnableOption "Enables gopass.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.password-store.package;
      description = "The gopass package to use.";
    };
    ssh-agent.enable = lib.mkEnableOption "gopass-backed SSH keys for git";
  };

  config = lib.mkIf config.security.gopass.enable {
    programs.password-store = {
      enable = true;
      package = pkgs.gopass.override { passAlias = true; };
      settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.local/share/pass";
      };
    };

    home.sessionVariables = {
      PASSWORD_STORE_DIR = config.programs.password-store.settings.PASSWORD_STORE_DIR;
    };

    home.file.".local/share/icons/hicolor/scalable/apps/gopass.svg" = {
      source = ../../../assets/icons/gopass.svg;
    };

    xdg.desktopEntries."gopass" = {
      name = "gopass";
      exec = "${lib.getExe config.terminal.kitty.package} --class gopass -e ${lib.getExe config.security.gopass.package}";
      icon = "gopass";
      comment = "Standard Unix password manager (Go implementation)";
      categories = [ "Utility" ];
      terminal = false;
      type = "Application";
    };
  };
}
