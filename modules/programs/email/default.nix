# email - Mbsync and notmuch mail synchronization
{
  config,
  lib,
  pkgs,
  ...
}:

let
  mailDir = "${config.home.homeDirectory}/.local/mail";
in
{
  options.programs.email = {
    enable = lib.mkEnableOption "Email suite (mbsync + notmuch)";
  };

  config = lib.mkIf config.programs.email.enable {
    home.packages = [
      pkgs.mbsync
      pkgs.notmuch
    ];

    home.sessionVariables = {
      MAILDIR = mailDir;
      NOTMUCH_CONFIG = "${config.xdg.configHome}/notmuch/notmuchrc";
    };

    xdg.configFile."notmuch/notmuch.config" = {
      text = ''
        [database]
        path=${mailDir}/.notmuch

        [user]
        name=
        address=
        primary_key=

        [new]
        tags=unclassified;new;
        ignore=

        [search]
        exclude_tags=deleted;spam;

        [maildir]
        synchronize_flags=true

        [crypto]
        gpg_path=${pkgs.gnupg}/bin/gpg
      '';
    };
  };
}
