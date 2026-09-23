{ ... }:
{
  # Calcurse - Template for configuring calcurse, specially syncing
  config.office.calcurse.sync = {
    remote = "YOUR_REPOSITORY_URL";
    credential = {
      username = "example";
      password-gopass-secret = "websites/github.com/example/tokens/calendar";
    };
  };

  # Email - Template for configuring neomutt email accounts
  config.communication.neomutt.accounts = {
    "example@gmail.com" = {
      real-name = "Example User";
      address = "user@gmail.com";
      password-gopass-secret = "mail/user@gmail.com";
      flavor = "gmail.com";
      primary = true;
      neomutt.extraConfig = ''
        set pgp_default_key = YOUR_GPG_KEY_FINGERPRINT
      '';
      gpg = {
        key = "YOUR_GPG_KEY_ID";
        sign-by-default = false;
        encrypt-by-default = false; # set true only if you also want auto-encrypt
      };
    };
  };

  # Senpai - Template for configuring senpai IRC client
  config.communication.senpai = {
    server = {
      address = "irc.example.com";
    };
    identity = {
      nickname = "example";
      password-gopass-secret = "irc/user@irc.example.com";
    };
  };

  # Git - Template for configuring git identity and signing
  config.development.git = {
    username = "Your Name";
    email = "you@example.com";
    signing = {
      key = "EXAMPLE_GPG_KEY_ID";
      sign-by-default = true;
    };
  };

  # SSH key to load into the gpg-agent from gopass (entry in the gopass store)
  config.security.ssh.ssh-key-gopass-secret = "ssh/hostname/username";

  # Gopass - Template for configuring gopass, specially syncing
  config.security.gopass.sync = {
    remote = "YOUR_REPOSITORY_URL";
    credential = {
      username = "example";
      password-gopass-secret = "websites/github.com/example/tokens/calendar";
    };
  };
}
