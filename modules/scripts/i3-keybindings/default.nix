{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "i3-keybindings";
    path = ./script.sh;
    description = "Path to your i3 config file";
    deps = [
      pkgs.coreutils
      pkgs.gawk
      pkgs.ncurses
    ];
    desktop = {
      enable = true;
      displayName = "i3 Keybindings";
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
