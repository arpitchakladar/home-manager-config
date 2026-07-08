{
  config,
  lib,
  pkgs,
  ...
}:

# OpenSSH - Secure shell (SSH) client for encrypted remote connections
{
  imports = [ ./git.nix ];

  config = lib.mkIf config.programs.ssh.enable {
    programs.ssh = {
      package = pkgs.openssh;
      enableDefaultConfig = false;
      extraOptionOverrides = {
        AddKeysToAgent = "yes";
        ForwardAgent = "yes";
        ServerAliveInterval = "60";
        ServerAliveCountMax = "3";
        VisualHostKey = "yes";
        HashKnownHosts = "yes";
      };
    };

    services.ssh-agent = {
      enable = true;
    };
  };
}
