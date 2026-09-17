# Mailbox synchronization
{
  config,
  lib,
  ...
}@inputs:
let
  mbsyncValue =
    value:
    if lib.isList value then
      lib.concatStringsSep " " (map mbsyncValue value)
    else if lib.isBool value then
      lib.hm.booleans.yesNo value
    else if lib.isInt value then
      toString value
    else if lib.isString value then
      if builtins.match ".* .*" value != null then ''"${lib.escape [ ''"'' ] value}"'' else value
    else
      throw "Unsupported mbsync value";

  mbsyncSection = name: attrs: ''
    ${name}
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "${n} ${mbsyncValue v}") attrs)}
  '';

  mbsyncAccount =
    account:
    let
      mbsyncNames = (import ../lib.nix inputs).mbsyncNamesFromName account.name;
    in
    lib.concatStringsSep "\n" [
      (mbsyncSection "IMAPAccount ${mbsyncNames.base}" (
        {
          Host = account.imap.host;
          User = account.userName;
          PipelineDepth = 50;
          TLSType =
            if !account.imap.tls.enable then
              "None"
            else if account.imap.tls.useStartTls then
              "STARTTLS"
            else
              "IMAPS";
        }
        // lib.optionalAttrs (account.passwordCommand != null) {
          PassCmd = toString account.passwordCommand;
        }
        // lib.optionalAttrs (account.imap.tls.certificatesFile != null) {
          CertificateFile = toString account.imap.tls.certificatesFile;
        }
        // lib.optionalAttrs (account.imap.port != null) {
          Port = account.imap.port;
        }
      ))

      (mbsyncSection "IMAPStore ${mbsyncNames.servers.remote}" {
        Account = mbsyncNames.base;
      })

      (mbsyncSection "MaildirStore ${mbsyncNames.servers.local}" {
        Path = "${account.maildir.absPath}/";
        Inbox = "${account.maildir.absPath}/${account.folders.inbox}";
        SubFolders = "Verbatim";
      })

      (mbsyncSection "Channel ${mbsyncNames.channels.quick}" {
        Far = ":${mbsyncNames.servers.remote}:\"INBOX\"";
        Near = ":${mbsyncNames.servers.local}:\"INBOX\"";
        Create = "Near";
        Expunge = "None";
        Sync = [
          "Pull"
          "New"
        ];
        SyncState = "*";
      })

      (mbsyncSection "Channel ${mbsyncNames.channels.full}" {
        Far = ":${mbsyncNames.servers.remote}:";
        Near = ":${mbsyncNames.servers.local}:";
        Patterns = account.mbsync.patterns;
        Create = "Near";
        Expunge = "Both";
        Sync = "All";
        SyncState = "*";
      })
    ];

  accounts = lib.filter (
    account: account.enable && account.mbsync.enable
  ) lib.attrValues config.accounts.email.accounts;
in
{
  config = lib.mkIf config.communication.neomutt.enable {
    programs.mbsync.enable = true;

    xdg.configFile."mbsync/.mbsyncrc".text = lib.concatStringsSep "\n" (map mbsyncAccount accounts);
  };
}
