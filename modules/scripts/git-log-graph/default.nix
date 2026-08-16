{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "git-log-graph";
    path = ./script.sh;
    description = "Git log graph with signature verification\nRun with GIT_LOG_GRAPH_EMBED=1 or --embed to skip the pager";
    deps = [
      pkgs.bash
      pkgs.git
      pkgs.git-graph
      pkgs.gawk
      pkgs.less
    ];
    completion = builtins.readFile ./completion.zsh;
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig;
}
