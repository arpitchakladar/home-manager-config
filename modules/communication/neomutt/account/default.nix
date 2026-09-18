# Converts neomutt account options into home-manager email config
{ config, lib, ... }:
{
  imports = [
    ./assertions.nix
  ];

  options.communication.neomutt.accounts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        imports = [
          ./options.nix
          ./flavors/gmail.nix
          ./sync-channel.nix
        ];
      }
    );
    default = { };
    description = "Specification of email accounts.";
  };

  config = lib.mkIf config.communication.neomutt.enable {
    accounts.email.accounts = lib.mapAttrs (accountName: accountInformation: {
      inherit (accountInformation) realName address primary;

      userName =
        if accountInformation.userName != null then
          accountInformation.userName
        else
          accountInformation.address;

      passwordCommand =
        if accountInformation.passwordGopassSecret != null then
          "${lib.getExe config.security.gopass.package} -o ${accountInformation.passwordGopassSecret}"
        else
          null;

      flavor = accountInformation.flavor;
      inherit (accountInformation) aliases;

      folders = {
        inherit (accountInformation.folders) inbox trash;
      }
      // lib.optionalAttrs (accountInformation.folders.drafts != null) {
        drafts = accountInformation.folders.drafts;
      }
      // lib.optionalAttrs (accountInformation.folders.sent != null) {
        sent = accountInformation.folders.sent;
      };

      neomutt = {
        enable = true;
        mailboxType = accountInformation.neomutt.mailboxType;
        extraConfig = accountInformation.neomutt.extraConfig;
      };

      mbsync = {
        enable = true;
        create = accountInformation.mbsync.create;
        patterns = accountInformation.mbsync.patterns;
        flatten = accountInformation.mbsync.flatten;
        extraConfig = {
          account = accountInformation.mbsync.extraConfig.account;
          channel = accountInformation.mbsync.extraConfig.channel;
          local = accountInformation.mbsync.extraConfig.local;
          remote = accountInformation.mbsync.extraConfig.remote;
        };
      };

      notmuch = {
        enable = true;
        neomutt = {
          enable = true;
          virtualMailboxes = accountInformation.notmuch.neomutt.virtualMailboxes;
        };
      };

      imap = lib.optionalAttrs (accountInformation.imap.host != null) {
        host = accountInformation.imap.host;
        port = accountInformation.imap.port;
        tls = {
          enable = accountInformation.imap.tls.enable;
          useStartTls = accountInformation.imap.tls.useStartTls;
        };
      };

      smtp = lib.optionalAttrs (accountInformation.smtp.host != null) {
        host = accountInformation.smtp.host;
        port = accountInformation.smtp.port;
        tls = {
          enable = accountInformation.smtp.tls.enable;
          useStartTls = accountInformation.smtp.tls.useStartTls;
        };
      };

      gpg = lib.optionalAttrs (accountInformation.gpg.key != null) {
        key = accountInformation.gpg.key;
        signByDefault = accountInformation.gpg.signByDefault;
        encryptByDefault = accountInformation.gpg.encryptByDefault;
      };

      signature =
        lib.optionalAttrs
          (accountInformation.signature.text != null || accountInformation.signature.command != null)
          {
            text = accountInformation.signature.text;
            command = accountInformation.signature.command;
            showSignature = accountInformation.signature.showSignature;
          };
    }) (lib.filterAttrs (n: a: a.enable) config.communication.neomutt.accounts);
  };
}
