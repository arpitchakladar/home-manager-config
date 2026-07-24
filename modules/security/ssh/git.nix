# Git - SSH host configurations for git platforms (github, gitlab, bitbucket, codeberg, sr.ht)
{ config, lib, ... }:
let
  hosts = [
    "github.com"
    "gitlab.com"
    "bitbucket.org"
    "codeberg.org"
    "git.sr.ht"
  ];

  mkGitHost =
    domain:
    lib.nameValuePair domain {
      hostname = domain;
      user = "git";
    };
in
{
  config = lib.mkIf (config.security.ssh.enable && config.development.git.useSSH) {
    programs.ssh.settings = builtins.listToAttrs (map mkGitHost hosts);
  };
}
