{ ... }:
{
  # Calcurse - Template for configuring calcurse, specially syncing
  config.office.calcurse.sync = {
    remote = "YOUR_REPOSITORY_URL";
    credential = {
      username = "example";
      passwordGopassPath = "websites/github.com/example/tokens/calendar";
    };
  };

  # Email - Template for configuring neomutt email accounts
  config.communication.neomutt.accounts = {
    "example@gmail.com" = {
      realName = "Example User";
      address = "user@gmail.com";
      passwordGopassSecret = "mail/user@gmail.com";
      flavor = "gmail.com";
      primary = true;
      neomutt.extraConfig = ''
        set pgp_default_key = YOUR_GPG_KEY_FINGERPRINT
      '';
      gpg = {
        key = "YOUR_GPG_KEY_ID";
        signByDefault = true;
        encryptByDefault = false; # set true only if you also want auto-encrypt
      };
    };
  };

  # Git - Template for configuring git identity and signing
  config.development.git = {
    username = "Your Name";
    email = "you@example.com";
    signing = {
      key = "EXAMPLE_GPG_KEY_ID";
      signByDefault = true;
    };
  };

  # SSH keys to load from gopass (entries under ssh/ in the gopass store)
  config.security.ssh.gopassKeys = [
    "github"
    "gitlab"
  ];

  # Gopass - Template for configuring gopass, specially syncing
  config.security.gopass.sync = {
    remote = "YOUR_REPOSITORY_URL";
    credential = {
      username = "example";
      passwordGopassPath = "websites/github.com/example/tokens/calendar";
    };
  };
}
