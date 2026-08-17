# Secure shell client for encrypted remote connections
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.security.ssh = {
    enable = lib.mkEnableOption "Enables ssh.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.ssh.package;
      description = "The ssh package to use.";
    };

    gopassKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "SSH keys to load from the gopass store (entries under ssh/).";
    };
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

    services.ssh-agent.enable = lib.mkIf config.security.gpg.enable false;
  };
}
