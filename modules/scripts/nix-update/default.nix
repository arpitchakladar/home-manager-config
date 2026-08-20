{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "nix-update";
    path = ./script.sh;
    description = "Update NixOS and/or Home Manager flake configuration\nRuns nix flake update and rebuilds the system";
    deps = [
      pkgs.git
      pkgs.nix
      config.programs.home-manager.package
      pkgs.bash
    ];
    completion.zsh = builtins.readFile ./completion.zsh;
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig;
}
