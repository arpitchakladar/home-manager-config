# Open-source reimplementation of the Cloudflare WARP client's MASQUE protocol
{
  config,
  pkgs,
  lib,
  ...
}:
let
  usqueWarpScript = pkgs.writeShellApplication {
    name = "usque-warp";
    runtimeInputs = [
      config.networking.usque.package
      pkgs.bash
    ];
    text = builtins.readFile ./usque-warp.sh;
  };

  usqueWarpCompletion =
    pkgs.runCommand "usque-warp-completion"
      {
        nativeBuildInputs = [ pkgs.installShellFiles ];
      }
      ''
        mkdir -p $out/share/zsh/site-functions
        installShellCompletion --zsh --name _usque-warp ${pkgs.writeText "usque-warp.zsh" (builtins.readFile ./usque-warp.zsh)}
      '';

  usqueWarpScriptPkg = pkgs.symlinkJoin {
    name = "usque-warp";
    paths = [
      usqueWarpScript
      usqueWarpCompletion
    ];
    meta = usqueWarpScript.meta or { };
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

    warp = {
      enable = lib.mkEnableOption "Enables the usque-warp script.";
      package = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        default = usqueWarpScriptPkg;
        description = "The usque-warp script package.";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.networking.usque.enable {
      home.packages = [ config.networking.usque.package ];
    })
    (lib.mkIf config.networking.usque.warp.enable {
      home.packages = [ config.networking.usque.warp.package ];
    })
  ];
}
