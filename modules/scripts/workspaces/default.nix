{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "eww-workspaces";
    path = ./script.sh;
    description = "Outputs JSON array of workspaces for eww bar\nUsed by eww to display workspace indicators in the sidebar";
    deps = [
      pkgs.bash
      pkgs.jq
    ];
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig;
}
