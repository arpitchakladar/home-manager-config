{ ... }:

{
  config.communication.neomutt.accounts = {
    "example" = {
      realName = "Example User";
      address = "user@gmail.com";
      passwordGopassSecret = "mail/user@gmail.com";
      flavor = "gmail.com";
      primary = true;
    };
  };
}
