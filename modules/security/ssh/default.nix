# OpenSSH - Secure shell (SSH) client for encrypted remote connections
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./git.nix ];

  options.security.ssh = {
    enable = lib.mkEnableOption "Enables ssh.";
  };

  config = lib.mkIf config.security.ssh.enable {
    programs.ssh = {
      enable = true;
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
  };
}
