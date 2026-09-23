# Senpai TUI IRC client module
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.communication.senpai;
in
{
  imports = [ ./assertions.nix ];

  options.communication.senpai = {
    enable = lib.mkEnableOption "Senpai TUI IRC client";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.senpai;
      description = "The senpai package to use.";
    };

    server = lib.mkOption {
      type = lib.types.submodule {
        options = {
          address = lib.mkOption {
            type = lib.types.str;
            description = "IRC server address (host[:port]). Supports irc://, ircs://, irc+insecure:// URLs.";
          };
        };
      };
      default = { };
      description = "IRC server configuration.";
    };

    identity = lib.mkOption {
      type = lib.types.submodule {
        options = {
          nickname = lib.mkOption {
            type = lib.types.str;
            description = "Your IRC nickname (no spaces or colons).";
          };

          password-gopass-secret = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Gopass secret path for SASL password (e.g. irc/user@server). Constructs password-cmd automatically.";
          };
        };
      };
      default = { };
      description = "Identity configuration.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.senpai = {
        enable = true;
        package = cfg.package;
        config = {
          address = cfg.server.address;
          nickname = cfg.identity.nickname;
          password-cmd = lib.mkIf (cfg.identity.password-gopass-secret != null) [
            (lib.getExe config.security.gopass.package)
            "show"
            "-o"
            cfg.identity.password-gopass-secret
          ];
        };
      };
    })
    (lib.mkIf (cfg.enable && config.terminal.kitty.enable) {
      xdg.desktopEntries."senpai" = {
        name = "Senpai";
        exec = "${lib.getExe config.terminal.kitty.package} --class senpai -e ${lib.getExe cfg.package}";
        icon = "senpai";
        categories = [
          "Network"
          "Chat"
        ];
        comment = "Senpai TUI IRC Client";
        terminal = false;
        type = "Application";
      };

      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/irc" = "senpai.desktop";
        "x-scheme-handler/ircs" = "senpai.desktop";
      };
    })
  ];
}
