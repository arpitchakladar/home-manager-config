{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "eww-active-windows";
    path = ./script.sh;
    description = "Outputs JSON array of active windows for eww bar\nUsed by eww to display window icons in the sidebar";
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
