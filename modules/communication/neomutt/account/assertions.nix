# Validates the neomutt account configurations
{ config, lib, ... }:
let
  cfg = config.communication.neomutt;
in
{
  config.assertions = [
    {
      assertion =
        !cfg.enable
        || !lib.any (account: account.enable && account.password-gopass-secret != null) (
          lib.attrValues cfg.accounts
        )
        || config.security.gopass.enable;
      message = ''
        An enabled communication.neomutt account uses password-gopass-secret but security.gopass.enable is not set.
        Enable security.gopass to provide the account password command.
      '';
    }
    {
      assertion =
        !cfg.enable
        || !lib.any (account: account.enable && account.gpg.key != null) (lib.attrValues cfg.accounts)
        || config.security.gpg.enable;
      message = ''
        An enabled communication.neomutt account specifies a GPG key but security.gpg.enable is not set.
        Enable security.gpg to provide mail signing and encryption support.
      '';
    }
  ];
}
