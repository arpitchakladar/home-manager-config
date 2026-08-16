{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;

  gitPlatformKeys = [
    "github"
    "gitlab"
    "bitbucket"
    "codeberg"
    "srht"
  ];

  gopassKeys =
    lib.optionals config.development.git.useSSH gitPlatformKeys ++ config.security.ssh.extraGopassKeys;

  base = mkScriptModule {
    name = "gopass-ssh-load";
    path = ./script.sh;
    description = "Load SSH keys from gopass password store";
    env = {
      GNUPGHOME = config.home.sessionVariables.GNUPGHOME;
      GOPASS_SSH_KEYS = lib.concatStringsSep " " gopassKeys;
    };
    deps = with pkgs; [
      config.security.gopass.package
      gnupg
      openssh
      bash
    ];
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig;
}
