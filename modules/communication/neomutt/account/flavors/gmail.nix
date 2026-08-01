# Gmail - Gmail-specific defaults for folder names, mbsync patterns, and mailboxes
{
  config,
  lib,
  name,
  ...
}:
{
  config = lib.mkIf (config.flavor == "gmail.com") {
    folders = {
      inbox = lib.mkDefault "Inbox";
      drafts = lib.mkDefault "[Gmail]/Drafts";
      sent = lib.mkDefault "[Gmail]/Sent Mail";
      trash = lib.mkDefault "[Gmail]/Trash";
    };

    mbsync = {
      create = lib.mkDefault "maildir";
      patterns = lib.mkDefault [
        "INBOX"
        "[Gmail]/Drafts"
        "[Gmail]/Sent Mail"
        "[Gmail]/Spam"
        "[Gmail]/Trash"
      ];
      extraConfig.channel = {
        Sync = lib.mkDefault "All";
        CopyArrivalDate = lib.mkDefault "yes";
        Expunge = lib.mkDefault "Both";
        SyncState = lib.mkDefault "*";
      };
    };

    neomutt.extraConfig = lib.mkDefault ''
      mailboxes =Inbox ="[Gmail]/Drafts" ="[Gmail]/Sent Mail" ="[Gmail]/Spam" ="[Gmail]/Trash"
      unset record
    '';

    notmuch.neomutt.virtualMailboxes = lib.mkDefault [
      {
        name = "All Mail";
        query = "folder:${name}/Inbox or folder:\"${name}/[Gmail]/Sent Mail\"";
      }
    ];
  };
}
