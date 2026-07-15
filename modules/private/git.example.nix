{ ... }:

{
  config.development.git = {
    username = "Arpit Chakladar";
    email = "arpitchakladar+git@gmail.com";
    signing = {
      key = "EXAMPLE_GPG_KEY_ID";
      signByDefault = true;
    };
  };
}
