{
  config,
  lib,
  ...
}:

let
  mailDir = "${config.home.homeDirectory}/.local/share/mail";
in
{
  options.communication.email = {
    enable = lib.mkEnableOption "Email suite (mbsync + notmuch)";

    accounts = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Email accounts. Each attribute name is an account identifier.";
    };
  };

  config = lib.mkIf config.communication.email.enable {
    programs.mbsync.enable = true;
    programs.notmuch.enable = true;

    accounts.email.maildirBasePath = mailDir;
    accounts.email.accounts = config.communication.email.accounts;

    home.sessionVariables.MAILDIR = mailDir;
  };
}
