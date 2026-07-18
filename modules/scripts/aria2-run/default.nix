{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "aria2-run";
    path = ./script.sh;
    description = "Start aria2 RPC daemon";
    deps = [ config.web.aria2.package ];
    desktop = {
      enable = true;
      displayName = "Aria2 Download Manager";
    };
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig // {
    assertions = base.moduleConfig.assertions ++ (import ./assertions.nix { inherit config lib; });
  };
}
