# Assertions - Validates SSH is enabled when git.useSSH is set
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
  ];
}
