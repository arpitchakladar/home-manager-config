{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "usque-warp";
    path = ./script.sh;
    description = "Connect/disconnect to Cloudflare WARP via usque MASQUE tunnel";
    deps = [
      config.networking.usque.package
      pkgs.bash
    ];
    completion.zsh = builtins.readFile ./completion.zsh;
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig;
}
