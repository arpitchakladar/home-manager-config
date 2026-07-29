{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "gopass-ssh-load";
    path = ./script.sh;
    description = "Load SSH keys from gopass password store";
    deps = with pkgs; [
      config.security.gopass.package
      gnupg
      openssh
    ];
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig;
}
