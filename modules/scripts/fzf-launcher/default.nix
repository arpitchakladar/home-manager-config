{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "fzf-launcher";
    path = ./script.sh;
    description = "Fzf-launcher - FZF-based application launcher (scans .desktop files)";
    deps = [
      config.terminal.fzf.package
      pkgs.dex
      pkgs.util-linux
    ];
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig // {
    assertions = base.moduleConfig.assertions ++ (import ./assertions.nix { inherit config lib; });
  };
}
