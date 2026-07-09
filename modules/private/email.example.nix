{ config, lib, ... }:

{
  config.accounts.email.accounts = {
    "example" = {
      realName = "example";
      address = "user@gmail.com";
      userName = "user@gmail.com";
      passwordCommand = "${lib.getExe config.programs.gopass.package} -o mail/user@gmail.com";
      flavor = "gmail.com";
      primary = true;
      neomutt.enable = true;

      mbsync = {
        enable = true;
        create = "maildir";
        patterns = [
          "INBOX"
          "\"[Gmail]/All Mail\""
          "\"[Gmail]/Sent Mail\""
          "\"[Gmail]/Drafts\""
          "\"[Gmail]/Spam\""
          "\"[Gmail]/Trash\""
        ];
        extraConfig.channel = {
          SyncState = "*";
        };
      };

      notmuch.enable = true;
    };
  };
}
