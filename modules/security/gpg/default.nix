# gpg - GNU Privacy Guard
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.security.gpg = {
    enable = lib.mkEnableOption "Enables gpg.";

    package = lib.mkOption {
      type = lib.types.package;
      default = config.programs.gpg.package;
      readOnly = true;
      defaultText = lib.literalExpression "config.programs.gpg.package";
      description = "The gpg package to use.";
    };
  };

  config = lib.mkIf config.security.gpg.enable {
    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    home.sessionVariables = {
      GNUPGHOME = config.programs.gpg.homedir;
    };

    services.gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      defaultCacheTtl = 3600;
      maxCacheTtl = 86400;
      enableSshSupport = config.security.ssh.enable;
      pinentry.package = pkgs.pinentry-rofi;
    };
  };
}
