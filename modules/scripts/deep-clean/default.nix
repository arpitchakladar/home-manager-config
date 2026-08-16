{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "deep-clean";
    path = ./script.sh;
    description = "Deep clean script for Nix systems\nRemoves old generations, garbage, and optimizes store\nWARNING: Do NOT run with sudo - run as normal user";
    deps = [
      pkgs.bash
    ];
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig;
}
