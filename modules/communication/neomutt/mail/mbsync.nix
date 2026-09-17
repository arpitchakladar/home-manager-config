{
  config,
  lib,
  ...
}@inputs:
let
  genValue =
    v:
    if lib.isList v then
      lib.concatStringsSep " " (map genValue v)
    else if lib.isBool v then
      lib.hm.booleans.yesNo v
    else if lib.isInt v then
      toString v
    else if lib.isString v then
      if builtins.match ".* .*" v != null then ''"${lib.escape [ ''"'' ] v}"'' else v
    else
      throw "Unsupported mbsync value";

  genSection = name: attrs: ''
    ${name}
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "${n} ${genValue v}") attrs)}
  '';

  genAccount =
    a:
    let
      mbsyncNames = (import ../lib.nix inputs).mbsyncNamesFromName a.name;

      quick = {
        Far = ":${mbsyncNames.servers.remote}:\"INBOX\"";
        Near = ":${mbsyncNames.servers.local}:\"INBOX\"";
        Create = "Near";
        Expunge = "None";
        Sync = [
          "Pull"
          "New"
        ];
        SyncState = "*";
      };

      full = {
        Far = ":${mbsyncNames.servers.remote}:";
        Near = ":${mbsyncNames.servers.local}:";
        Patterns = a.mbsync.patterns;
        Create = "Near";
        Expunge = "Both";
        Sync = "All";
        SyncState = "*";
      };
    in
    genSection "IMAPAccount ${mbsyncNames.base}" (
      {
        Host = a.imap.host;
        User = a.userName;
        PipelineDepth = 50;
        TLSType =
          if !a.imap.tls.enable then
            "None"
          else if a.imap.tls.useStartTls then
            "STARTTLS"
          else
            "IMAPS";
      }
      // lib.optionalAttrs (a.passwordCommand != null) {
        PassCmd = toString a.passwordCommand;
      }
      // lib.optionalAttrs (a.imap.tls.certificatesFile != null) {
        CertificateFile = toString a.imap.tls.certificatesFile;
      }
      // lib.optionalAttrs (a.imap.port != null) {
        Port = a.imap.port;
      }
    )

    + "\n"
    + genSection "IMAPStore ${mbsyncNames.servers.remote}" {
      Account = mbsyncNames.base;
    }

    + "\n"
    + genSection "MaildirStore ${mbsyncNames.servers.local}" {
      Path = "${a.maildir.absPath}/";
      Inbox = "${a.maildir.absPath}/${a.folders.inbox}";
      SubFolders = "Verbatim";
    }

    + "\n"
    + genSection "Channel ${mbsyncNames.channels.quick}" quick

    + "\n"
    + genSection "Channel ${mbsyncNames.channels.full}" full

    + "\n";

  accounts = lib.filter (a: a.enable && a.mbsync.enable) (
    lib.attrValues config.accounts.email.accounts
  );

in
{
  config = lib.mkIf config.communication.neomutt.enable {
    programs.mbsync.enable = true;

    xdg.configFile."mbsync/.mbsyncrc".text = lib.concatStringsSep "\n" (map genAccount accounts);
  };
}
