{ config, lib, ... }:

let
  hosts = [
    {
      domain = "github.com";
      identityName = "github";
    }
    {
      domain = "gitlab.com";
      identityName = "gitlab";
    }
    {
      domain = "bitbucket.org";
      identityName = "bitbucket";
    }
    {
      domain = "codeberg.org";
      identityName = "codeberg";
    }
    {
      domain = "git.sr.ht";
      identityName = "sourcehut";
    }
  ];

  mkGitHost =
    { domain, identityName }:
    lib.nameValuePair domain {
      hostname = domain;
      user = "git";
      identityFile = "${config.home.homeDirectory}/.local/share/ssh/git/${identityName}";
    };

  mkKeyFile =
    { identityName, ... }:
    lib.nameValuePair identityName {
      enable = true;
      text = "";
      force = false;
    };
in
{
  config = lib.mkIf (config.security.ssh.enable && config.development.git.useSSH) {
    home.file = builtins.listToAttrs (map mkKeyFile hosts);

    programs.ssh.settings = builtins.listToAttrs (map mkGitHost hosts);
  };
}
