{ config, ... }:

{
  config.accounts.email.accounts = {
    "example" = {
      realName = "Example User";
      address = "user@example.com";
      userName = "user@example.com";
      passwordCommand = "${config.programs.gopass.package}/bin/gopass show -o mail/example";
      flavor = "gmail.com";
      primary = true;

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
}
