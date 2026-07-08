{ config, ... }:
{
  assertions = [
    {
      assertion =
        !config.programs.git.useSSH || (config.programs.git.enable && config.programs.ssh.enable);
      message = ''
        programs.git.useSSH is enabled but programs.ssh.enable is not.
        SSH must be enabled (programs.ssh.enable = true) to use SSH for git.
      '';
    }
  ];
}
