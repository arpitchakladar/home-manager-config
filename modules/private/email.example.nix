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

      neomutt.extraConfig = ''
        mailboxes "+Inbox" "+[Gmail]/Drafts" "+[Gmail]/Spam" "+[Gmail]/Trash"
      '';

      mbsync = {
        enable = true;
        create = "maildir";
        patterns = [
          "Inbox"
          "\"[Gmail]/Drafts\""
          "\"[Gmail]/Spam\""
          "\"[Gmail]/Trash\""
        ];
        extraConfig.channel = {
          SyncState = "*";
          Sync = "All";
          CopyArrivalDate = "yes";
        };
      };

      notmuch.enable = true;
    };
  };
}
