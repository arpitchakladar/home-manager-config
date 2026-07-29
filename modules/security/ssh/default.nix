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

      package =
        if (config.security.gopass.enable or false && config.security.gopass.ssh-agent.enable or false) then
          pkgs.symlinkJoin {
            name = "openssh-gopass-wrapper";
            paths = [ pkgs.openssh ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/ssh \
                --run "${config.security.gopass.ssh-agent.script}/bin/gopass-ssh-load"
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
