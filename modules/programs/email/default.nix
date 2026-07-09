# email - Mbsync and notmuch mail synchronization
{
  config,
  lib,
  ...
}:

let
  mailDir = "${config.home.homeDirectory}/.local/share/mail";
in
{
  options.programs.email = {
    enable = lib.mkEnableOption "Email suite (mbsync + notmuch)";
  };

  config = lib.mkIf config.programs.email.enable {
    programs.mbsync.enable = true;
    programs.notmuch.enable = true;

    accounts.email.maildirBasePath = mailDir;

    home.sessionVariables.MAILDIR = mailDir;
  };
}
