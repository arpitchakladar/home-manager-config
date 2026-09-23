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
          ./flavors/gmail
          ./options.nix
          ./sync-channel.nix
        ];
      }
    );
    default = { };
    description = "Specification of email accounts.";
  };

  config = lib.mkIf config.communication.neomutt.enable {
    accounts.email.accounts = lib.mapAttrs (accountName: accountInformation: {
      inherit (accountInformation) address primary;

      realName = accountInformation.real-name;

      userName =
        if accountInformation.username != null then
          accountInformation.username
        else
          accountInformation.address;

      passwordCommand =
        if accountInformation.password-gopass-secret != null then
          "${lib.getExe config.security.gopass.package} -o ${accountInformation.password-gopass-secret}"
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
        mailboxType = accountInformation.neomutt.mailbox-type;
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
          virtualMailboxes = accountInformation.notmuch.neomutt.virtual-mailboxes;
        };
      };

      imap = lib.optionalAttrs (accountInformation.imap.host != null) {
        host = accountInformation.imap.host;
        port = accountInformation.imap.port;
        tls = {
          enable = accountInformation.imap.tls.enable;
          useStartTls = accountInformation.imap.tls.use-start-tls;
        };
      };

      smtp = lib.optionalAttrs (accountInformation.smtp.host != null) {
        host = accountInformation.smtp.host;
        port = accountInformation.smtp.port;
        tls = {
          enable = accountInformation.smtp.tls.enable;
          useStartTls = accountInformation.smtp.tls.use-start-tls;
        };
      };

      gpg = lib.optionalAttrs (accountInformation.gpg.key != null) {
        key = accountInformation.gpg.key;
        signByDefault = accountInformation.gpg.sign-by-default;
        encryptByDefault = accountInformation.gpg.encrypt-by-default;
      };

      signature =
        lib.optionalAttrs
          (accountInformation.signature.text != null || accountInformation.signature.command != null)
          {
            text = accountInformation.signature.text;
            command = accountInformation.signature.command;
            showSignature = accountInformation.signature.show-signature;
          };
    }) (lib.filterAttrs (n: a: a.enable) config.communication.neomutt.accounts);
  };
}
