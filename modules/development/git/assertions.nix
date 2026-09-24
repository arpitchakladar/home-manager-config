# Validates SSH is enabled when git.useSSH is set
{ config, ... }:
let
  cfg = config.development.git;
in
{
  assertions = [
    {
      assertion = !cfg.signing.sign-by-default || cfg.enable;
      message = ''
        development.git.signing.sign-by-default is enabled but development.git.enable is not.
        Enable development.git before enabling commit signing.
      '';
    }
    {
      assertion = !cfg.signing.sign-by-default || cfg.signing.key != null;
      message = ''
        development.git.signing.sign-by-default is enabled but development.git.signing.key is not set.
        Set a GPG key ID before enabling commit signing by default.
      '';
    }
    {
      assertion = !cfg.signing.sign-by-default || config.security.gpg.enable;
      message = ''
        development.git.signing.sign-by-default is enabled but security.gpg.enable is not.
        Commit signing requires the managed GPG configuration. Please enable security.gpg.
      '';
    }
  ];
}
