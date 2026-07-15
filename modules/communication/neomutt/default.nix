{ config, lib, ... }:

{
  imports = [
    ./account
    ./sync
    ./neomutt.nix
    ./assertions.nix
    ./theme.nix
  ];

  options.communication.neomutt = {
    enable = lib.mkEnableOption "Email suite (neomutt + mbsync + notmuch)";
  };

  config = lib.mkIf config.communication.neomutt.enable {
    accounts.email.maildirBasePath = "${config.home.homeDirectory}/.local/share/mail";
    home.sessionVariables.MAILDIR = config.accounts.email.maildirBasePath;
  };
}
