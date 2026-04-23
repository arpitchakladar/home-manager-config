{
  config,
  lib,
  pkgs,
  ...
}:

# OpenSSH - Secure shell (SSH) client for encrypted remote connections
{
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
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "${config.home.homeDirectory}/.ssh/github";
        };
      };
    };
  };
}
