# Update NixOS and/or Home Manager flake configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../../lib/script.nix { inherit lib pkgs; })) mkScriptModule;
in
mkScriptModule {
  scope = [ "system" ];
  name = "nix-update";
  path = ./nix-update.sh;
  description = "Update NixOS and/or Home Manager flake configuration\nRuns nix flake update and rebuilds the system";
  deps = [
    pkgs.git
    pkgs.nix
    config.programs.home-manager.package
    pkgs.bash
  ];
  completion.zsh = builtins.readFile ./nix-update.zsh;
  inherit config;
}
