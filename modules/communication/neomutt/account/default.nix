{ config, lib, ... }:

with lib;

let
  inherit (lib) types;
in
{
  options.communication.neomutt.accounts = mkOption {
    type = types.attrsOf (
      types.submodule {
        imports = [
          ./options.nix
          ./flavors/gmail.nix
        ];
      }
    );
    default = { };
    description = "Specification of email accounts.";
  };

  config = mkIf config.communication.neomutt.enable {
    accounts.email.accounts = mapAttrs (
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
        // optionalAttrs (a.folders.drafts != null) { drafts = a.folders.drafts; }
        // optionalAttrs (a.folders.sent != null) { sent = a.folders.sent; };

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

        imap = optionalAttrs (a.imap.host != null) {
          host = a.imap.host;
          port = a.imap.port;
          tls = {
            enable = a.imap.tls.enable;
            useStartTls = a.imap.tls.useStartTls;
          };
        };

        smtp = optionalAttrs (a.smtp.host != null) {
          host = a.smtp.host;
          port = a.smtp.port;
          tls = {
            enable = a.smtp.tls.enable;
            useStartTls = a.smtp.tls.useStartTls;
          };
        };

        gpg = optionalAttrs (a.gpg.key != null) {
          key = a.gpg.key;
          signByDefault = a.gpg.signByDefault;
          encryptByDefault = a.gpg.encryptByDefault;
        };

        signature = optionalAttrs (a.signature.text != null || a.signature.command != null) {
          text = a.signature.text;
          command = a.signature.command;
          showSignature = a.signature.showSignature;
        };
      }
    ) (filterAttrs (n: a: a.enable) config.communication.neomutt.accounts);
  };
}
