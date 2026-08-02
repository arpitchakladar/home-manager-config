# Neomutt - Email suite entry point (neomutt + mbsync + notmuch)
{
  config,
  lib,
  ...
}:
{
  imports = [
    ./account
    ./sync
    ./assertions.nix
    ./keybindings.nix
    ./macros.nix
    ./neomutt.nix
  ];

  options.communication.neomutt = {
    enable = lib.mkEnableOption "Email suite (neomutt + mbsync + notmuch)";

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.neomutt.package;
      description = "The neomutt package to use, wrapped with urlscan in PATH.";
    };
  };

  config = lib.mkIf config.communication.neomutt.enable {
    accounts.email.maildirBasePath = "${config.home.homeDirectory}/.local/share/mail";
    home.sessionVariables.MAILDIR = config.accounts.email.maildirBasePath;
  };
}
