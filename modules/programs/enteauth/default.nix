{
  config,
  lib,
  pkgs,
  ...
}:

# Ente Auth - end-to-end encrypted authentication (2FA)
let
  enteAuthWithKeyring = pkgs.symlinkJoin {
    name = "ente-auth-wrapped";
    paths = [ pkgs.ente-auth ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/enteauth \
        --prefix PATH : ${
          lib.makeBinPath [
            pkgs.gnome-keyring
            pkgs.dbus
          ]
        } \
        --run "echo 'password' | ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --unlock --components=secrets"

      rm -rf $out/share/applications/*

      ln -s ${customDesktopItem}/share/applications/* $out/share/applications/
    '';
  };

  customDesktopItem = pkgs.makeDesktopItem {
    name = "enteauth";
    exec = "enteauth";
    icon = "io.ente.auth";
    comment = "End-to-end encrypted 2FA authenticator";
    desktopName = "Ente Auth";
    genericName = "2FA Authenticator";
    categories = [
      "Utility"
      "Security"
    ];
    terminal = false;
  };
in
{
  options.programs.enteauth = {
    enable = lib.mkEnableOption "Enables wrapped ente-auth with automated keyring unlocks and a desktop entry.";
    package = lib.mkOption {
      type = lib.types.package;
      default = enteAuthWithKeyring;
      description = "The customized version of ente-auth with a self-unlocking daemon backend.";
    };
  };

  config = lib.mkIf config.programs.enteauth.enable {
    home.packages = [ config.programs.enteauth.package ];
  };
}
