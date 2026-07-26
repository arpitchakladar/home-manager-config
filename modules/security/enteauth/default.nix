# Ente Auth - end-to-end encrypted authentication (2FA)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.security.enteauth = {
    enable = lib.mkEnableOption "Enables wrapped ente-auth with automated keyring unlocks and a desktop entry.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ente-auth;
      description = "The customized version of ente-auth with a self-unlocking daemon backend.";
    };
  };

  config = lib.mkIf config.security.enteauth.enable {
    home.packages = [ config.security.enteauth.package ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/enteauth" = "enteauth.desktop";
    };
  };
}
