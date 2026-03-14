{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.tools.openssh = {
    enable = lib.mkEnableOption "Enables OpenSSH client.";
  };

  config = lib.mkIf config.tools.openssh.enable {
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
