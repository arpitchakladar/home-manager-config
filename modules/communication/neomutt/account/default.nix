# Account - Converts neomutt account options into home-manager email config
{ config, lib, ... }:
{
  options.communication.neomutt.accounts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        imports = [
          ./options.nix
          ./flavors/gmail.nix
        ];
      }
    );
    default = { };
    description = "Specification of email accounts.";
  };

  config = {
    assertions = [
      {
        assertion =
          !config.communication.neomutt.enable
          || !lib.any (account: account.enable && account.passwordGopassSecret != null) (
            lib.attrValues config.communication.neomutt.accounts
          )
          || config.security.gopass.enable;
        message = ''
          An enabled communication.neomutt account uses passwordGopassSecret but security.gopass.enable is not set.
          Enable security.gopass to provide the account password command.
        '';
      }
      {
        assertion =
          !config.communication.neomutt.enable
          || !lib.any (account: account.enable && account.gpg.key != null) (
            lib.attrValues config.communication.neomutt.accounts
          )
          || config.security.gpg.enable;
        message = ''
          An enabled communication.neomutt account specifies a GPG key but security.gpg.enable is not set.
          Enable security.gpg to provide mail signing and encryption support.
        '';
      }
    ];

  }
  // lib.mkIf config.communication.neomutt.enable {
    accounts.email.accounts = lib.mapAttrs (
      name: account:
      let
        a = account;
      in
      {
        inherit (a) realName address primary;
        userName = if a.userName != null then a.userName else a.address;

        passwordCommand =
          if a.passwordGopassSecret != null then
            "${lib.getExe config.security.gopass.package} -o ${a.passwordGopassSecret}"
          else
            null;

        flavor = a.flavor;
        inherit (a) aliases;

        folders = {
          inherit (a.folders) inbox trash;
        }
        // lib.optionalAttrs (a.folders.drafts != null) { drafts = a.folders.drafts; }
        // lib.optionalAttrs (a.folders.sent != null) { sent = a.folders.sent; };

        neomutt = {
          enable = true;
          mailboxType = a.neomutt.mailboxType;
          extraConfig = a.neomutt.extraConfig;
        };

        mbsync = {
          enable = true;
          create = a.mbsync.create;
          patterns = a.mbsync.patterns;
          flatten = a.mbsync.flatten;
          extraConfig = {
            account = a.mbsync.extraConfig.account;
            channel = a.mbsync.extraConfig.channel;
            local = a.mbsync.extraConfig.local;
            remote = a.mbsync.extraConfig.remote;
          };
        };

        notmuch = {
          enable = true;
          neomutt = {
            enable = true;
            virtualMailboxes = a.notmuch.neomutt.virtualMailboxes;
          };
        };

        imap = lib.optionalAttrs (a.imap.host != null) {
          host = a.imap.host;
          port = a.imap.port;
          tls = {
            enable = a.imap.tls.enable;
            useStartTls = a.imap.tls.useStartTls;
          };
        };

        smtp = lib.optionalAttrs (a.smtp.host != null) {
          host = a.smtp.host;
          port = a.smtp.port;
          tls = {
            enable = a.smtp.tls.enable;
            useStartTls = a.smtp.tls.useStartTls;
          };
        };

        gpg = lib.optionalAttrs (a.gpg.key != null) {
          key = a.gpg.key;
          signByDefault = a.gpg.signByDefault;
          encryptByDefault = a.gpg.encryptByDefault;
        };

        signature = lib.optionalAttrs (a.signature.text != null || a.signature.command != null) {
          text = a.signature.text;
          command = a.signature.command;
          showSignature = a.signature.showSignature;
        };
      }
    ) (lib.filterAttrs (n: a: a.enable) config.communication.neomutt.accounts);
  };
}
