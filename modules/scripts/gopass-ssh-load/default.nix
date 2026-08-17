{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;

  gopassKeys = config.security.ssh.gopassKeys;

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
