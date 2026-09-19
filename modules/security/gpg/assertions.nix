# Validates GPG sub-options require the main module to be enabled
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.security.gpg.backup.enable || config.security.gpg.enable;
      message = "security.gpg.backup.enable requires security.gpg.enable.";
    }
  ];
}
