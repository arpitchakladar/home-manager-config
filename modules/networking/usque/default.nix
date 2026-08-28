# Open-source reimplementation of the Cloudflare WARP client's MASQUE protocol
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit ((import ../../lib/script.nix { inherit lib pkgs; })) mkScriptModule;
  usqueWarp = mkScriptModule {
    scope = [
      "networking"
      "usque"
    ];
    name = "usque-warp";
    path = ./usque-warp.sh;
    description = "Connect/disconnect to Cloudflare WARP via usque MASQUE tunnel";
    deps = [
      config.networking.usque.package
      pkgs.bash
    ];
    completion.zsh = builtins.readFile ./usque-warp.zsh;
    inherit config;
  };
in
{
  options.networking.usque = {
    enable = lib.mkEnableOption "Enables usque.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.usque;
      description = "The usque package to use.";
    };
  }
  // usqueWarp.options.networking.usque;

  config = lib.mkMerge [
    (lib.mkIf config.networking.usque.enable {
      home.packages = [ config.networking.usque.package ];
    })
    usqueWarp.config
  ];
}
