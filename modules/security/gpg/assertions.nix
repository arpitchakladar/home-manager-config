# Validates GPG sub-options require the main module to be enabled
{ config, ... }:
let
  cfg = config.security.gpg;
in
{
  assertions = [
    {
      assertion = !cfg.backup.enable || cfg.enable;
      message = "security.gpg.backup.enable requires security.gpg.enable.";
    }
  ];
}
