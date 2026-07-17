# Options - Email account option definitions (realName, address, folders, gpg, etc.)
{ lib, ... }:

{
  options = {
    enable = lib.mkEnableOption "this email account" // {
      default = true;
    };

    realName = lib.mkOption {
      type = lib.types.str;
      description = "Name displayed when sending mails.";
    };

    address = lib.mkOption {
      type = lib.types.str;
      description = "Email address of this account.";
    };

    userName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Server username. Defaults to address if null.";
    };

    passwordGopassSecret = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Gopass secret path (e.g. mail/user@gmail.com). Constructs passwordCommand automatically.";
    };

    primary = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this is the primary account.";
    };

    flavor = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "gmail.com"
          "fastmail.com"
          "outlook.office365.com"
          "outlook.office365.com-ews"
          "mailbox.org"
          "migadu.com"
          "posteo.de"
          "runbox.com"
          "yandex.com"
          "davmail"
          "plain"
        ]
      );
      default = null;
      description = "Email provider flavor for automatic configuration.";
    };

    folders = {
      inbox = lib.mkOption {
        type = lib.types.str;
        default = "Inbox";
        description = "Inbox folder.";
      };

      drafts = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Drafts folder.";
      };

      sent = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Sent mail folder.";
      };

      trash = lib.mkOption {
        type = lib.types.str;
        default = "Trash";
        description = "Trash folder.";
      };
    };

    neomutt = {
      mailboxType = lib.mkOption {
        type = lib.types.enum [
          "maildir"
          "imap"
        ];
        default = "maildir";
        description = "Whether this account uses maildir folders or IMAP mailboxes.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Extra neomutt config lines for this account.";
      };
    };

    mbsync = {
      create = lib.mkOption {
        type = lib.types.enum [
          "none"
          "maildir"
          "imap"
          "both"
        ];
        default = "none";
        description = "Automatically create missing mailboxes.";
      };

      patterns = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "INBOX" ];
        description = "Mailbox patterns to synchronize.";
      };

      flatten = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Flatten hierarchy delimiter.";
      };

      extraConfig = {
        account = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.oneOf [
              lib.types.str
              lib.types.int
              lib.types.bool
              (lib.types.listOf lib.types.str)
            ]
          );
          default = { };
          description = "Account section extra configuration.";
        };

        channel = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.oneOf [
              lib.types.str
              lib.types.int
              lib.types.bool
              (lib.types.listOf lib.types.str)
            ]
          );
          default = { };
          description = "Channel extra configuration.";
        };

        local = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.oneOf [
              lib.types.str
              lib.types.int
              lib.types.bool
              (lib.types.listOf lib.types.str)
            ]
          );
          default = { };
          description = "Local store extra configuration.";
        };

        remote = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.oneOf [
              lib.types.str
              lib.types.int
              lib.types.bool
              (lib.types.listOf lib.types.str)
            ]
          );
          default = { };
          description = "Remote store extra configuration.";
        };
      };
    };

    notmuch = {
      neomutt = {
        virtualMailboxes = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Display name.";
                };

                query = lib.mkOption {
                  type = lib.types.str;
                  description = "Notmuch query.";
                };

                limit = lib.mkOption {
                  type = lib.types.nullOr lib.types.int;
                  default = null;
                  description = "Result limit.";
                };

                type = lib.mkOption {
                  type = lib.types.nullOr (
                    lib.types.enum [
                      "threads"
                      "messages"
                    ]
                  );
                  default = null;
                  description = "Result type.";
                };
              };
            }
          );
          default = [ ];
          description = "Virtual mailboxes from notmuch queries.";
        };
      };
    };

    imap = {
      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "IMAP server hostname.";
      };

      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = null;
        description = "IMAP server port.";
      };

      tls = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable TLS.";
        };

        useStartTls = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use STARTTLS.";
        };
      };
    };

    smtp = {
      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "SMTP server hostname.";
      };

      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = null;
        description = "SMTP server port.";
      };

      tls = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable TLS.";
        };

        useStartTls = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use STARTTLS.";
        };
      };
    };

    gpg = {
      key = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "GPG key to use.";
      };

      signByDefault = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Sign messages by default.";
      };

      encryptByDefault = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Encrypt messages by default.";
      };
    };

    signature = {
      text = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Signature text.";
      };

      command = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Command that generates a signature.";
      };

      showSignature = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "append"
            "attach"
            "none"
          ]
        );
        default = null;
        description = "Signature display method.";
      };
    };

    aliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Alternative email addresses for this account.";
    };
  };
}
