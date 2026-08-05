# Validates SSH is enabled when git.useSSH is set
{ config, ... }:
{
  assertions = [
    {
      assertion =
        !config.development.git.useSSH || (config.development.git.enable && config.security.ssh.enable);
      message = ''
        development.git.useSSH is enabled but security.ssh.enable is not.
        SSH must be enabled (security.ssh.enable = true) to use SSH for git.
      '';
    }
    {
      assertion = !config.development.git.signing.signByDefault || config.development.git.enable;
      message = ''
        development.git.signing.signByDefault is enabled but development.git.enable is not.
        Enable development.git before enabling commit signing.
      '';
    }
    {
      assertion =
        !config.development.git.signing.signByDefault || config.development.git.signing.key != null;
      message = ''
        development.git.signing.signByDefault is enabled but development.git.signing.key is not set.
        Set a GPG key ID before enabling commit signing by default.
      '';
    }
    {
      assertion = !config.development.git.signing.signByDefault || config.security.gpg.enable;
      message = ''
        development.git.signing.signByDefault is enabled but security.gpg.enable is not.
        Commit signing requires the managed GPG configuration. Please enable security.gpg.
      '';
    }
  ];
}
