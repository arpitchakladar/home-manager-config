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
  };

  config = lib.mkIf config.security.gpg.enable {
    programs.gpg = {
      enable = true;
    };

    services.gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      defaultCacheTtl = 3600;
      maxCacheTtl = 86400;
      enableSshSupport = config.security.ssh.enable;
      pinentry.package = pkgs.pinentry-gtk2;
    };
  };
}
