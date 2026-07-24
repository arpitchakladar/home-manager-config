# Email example - Template for configuring neomutt email accounts
{ ... }:
{
  config.communication.neomutt.accounts = {
    "example@gmail.com" = {
      realName = "Example User";
      address = "user@gmail.com";
      passwordGopassSecret = "mail/user@gmail.com";
      flavor = "gmail.com";
      primary = true;
    };
  };
}
