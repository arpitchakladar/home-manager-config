{ config, lib, ... }:

{
  config.accounts.email.accounts = {
    "example" = {
      realName = "Example User";
      address = "user@gmail.com";
      userName = "user@gmail.com";
      passwordCommand = "${lib.getExe config.programs.gopass.package} -o mail/user@gmail.com";
      flavor = "gmail.com";
      primary = true;
      neomutt = {
        enable = true;
        mailboxType = "maildir";
      };

      folders = {
        inbox = "Inbox";
        drafts = "[Gmail]/Drafts";
        sent = "[Gmail]/Sent Mail";
        trash = "[Gmail]/Trash";
      };

      mbsync = {
        enable = true;
        create = "maildir";
        patterns = [
          "INBOX"
          "\"[Gmail]/Drafts\""
          "\"[Gmail]/Sent Mail\""
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
