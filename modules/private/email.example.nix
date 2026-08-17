# Email example - Template for configuring neomutt email accounts
{ ... }:
{
  config = {
    communication.neomutt.accounts = {
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
  };
}
