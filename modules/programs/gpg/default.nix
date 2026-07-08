# gpg - GNU Privacy Guard
{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.programs.gpg.enable {
    services.gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      defaultCacheTtl = 3600;
      maxCacheTtl = 86400;
      pinentry.package = pkgs.pinentry-gtk2;
    };
  };
}
