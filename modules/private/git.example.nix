{ config, ... }:

{
  programs.git.signing = {
    key = "EXAMPLE_GPG_KEY_ID";
    signByDefault = true;
  };
}
