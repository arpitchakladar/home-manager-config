# Secure shell client for encrypted remote connections
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
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.ssh.package;
      description = "The ssh package to use.";
    };

    extraGopassKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional SSH keys to load from the gopass store (entries under ssh/), in addition to the git platform keys.";
    };
  };

  config = lib.mkIf config.security.ssh.enable {
    programs.ssh = {
      enable = true;

      package =
        if (config.security.gopass.enable or false && config.security.gopass.ssh-agent.enable or false) then
          pkgs.symlinkJoin {
            name = "openssh-gopass-wrapper";
            paths = [ pkgs.openssh ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/ssh \
                --run "${lib.getExe config.scripts.gopass-ssh-load.package}"
            '';
          }
        else
          pkgs.openssh;

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
