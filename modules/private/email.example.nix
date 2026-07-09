{ config, ... }:

let
  mailDir = "${config.home.homeDirectory}/.local/mail";
in
{
  accounts.email.accounts = {
    "example" = {
      realName = "Example User";
      address = "user@example.com";
      userName = "user@example.com";
      passwordCommand = "${config.programs.gopass.package}/bin/gopass show -o mail/example";
      flavor = "gmail.com";

      mbsync = {
        enable = true;
        createMailbox = true;
        extraConfig.channel = {
          Patterns = "*";
          SyncState = "*";
        };
      };

      notmuch.enable = true;

      mu.enable = false;
      msmtp.enable = false;
      imapnotify.enable = false;
    };
  };

  # Mbsync config
  programs.mbsync = {
    enable = true;
    directory = mailDir;
  };

  # Notmuch config
  programs.notmuch = {
    enable = true;
    database.path = "${mailDir}/.notmuch";
  };
}
