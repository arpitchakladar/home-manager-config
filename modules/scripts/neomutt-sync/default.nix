{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "neomutt-sync";
    path = ./script.sh;
    description = "Neomutt-sync - Interactive mail sync with dialog progress bar";
    deps = [
      pkgs.dialog
      pkgs.coreutils
      pkgs.gawk
      pkgs.gnused
      pkgs.util-linux
      config.programs.mbsync.package
      config.programs.notmuch.package
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
