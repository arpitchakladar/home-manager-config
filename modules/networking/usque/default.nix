# Open-source reimplementation of the Cloudflare WARP client's MASQUE protocol
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networking.usque;

  usqueWarpScript = pkgs.writeShellApplication {
    name = "usque-warp";
    runtimeInputs = [
      cfg.package
      config.terminal.bash.package
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
  imports = [ ./assertions.nix ];

  options.networking.usque = {
    enable = lib.mkEnableOption "Enables usque.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.usque;
      description = "The usque package to use.";
    };

    warp = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Enables the usque-warp script.";
          package = lib.mkOption {
            type = lib.types.package;
            readOnly = true;
            default = usqueWarpScriptPkg;
            description = "The usque-warp script package.";
          };
        };
      };
      default = { };
      description = "WARP script configuration.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];
    })
    (lib.mkIf cfg.warp.enable {
      home.packages = [ cfg.warp.package ];
    })
    (lib.mkIf (cfg.warp.enable && config.desktop.enable) {
      desktop.rofi.action.actions = [
        {
          name = "WARP Connect";
          command = "${lib.getExe cfg.warp.package} connect";
          icon = "network-vpn-symbolic";
        }
        {
          name = "WARP Disconnect";
          command = "${lib.getExe cfg.warp.package} disconnect";
          icon = "network-vpn-disconnected-symbolic";
        }
      ];
    })
  ];
}
