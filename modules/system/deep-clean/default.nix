# Deep clean script for Nix systems
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
  name = "deep-clean";
  path = ./deep-clean.sh;
  description = "Deep clean script for Nix systems\nRemoves old generations, garbage, and optimizes store\nWARNING: Do NOT run with sudo - run as normal user";
  deps = [ pkgs.bash ];
  inherit config;
}
