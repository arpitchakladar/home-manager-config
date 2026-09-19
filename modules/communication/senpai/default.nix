# Senpai TUI IRC client module
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./assertions.nix ];

  options.communication.senpai = {
    enable = lib.mkEnableOption "Senpai TUI IRC client";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.senpai;
      description = "The senpai package to use.";
    };

    server = {
      address = lib.mkOption {
        type = lib.types.str;
        description = "IRC server address (host[:port]). Supports irc://, ircs://, irc+insecure:// URLs.";
      };
    };

    identity = {
      nickname = lib.mkOption {
        type = lib.types.str;
        description = "Your IRC nickname (no spaces or colons).";
      };

      passwordGopassSecret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Gopass secret path for SASL password (e.g. irc/user@server). Constructs password-cmd automatically.";
      };
    };
  };

  config = lib.mkIf config.communication.senpai.enable {
    programs.senpai = {
      enable = true;
      package = config.communication.senpai.package;
      config = {
        address = config.communication.senpai.server.address;
        nickname = config.communication.senpai.identity.nickname;
        password-cmd = lib.mkIf (config.communication.senpai.identity.passwordGopassSecret != null) [
          (lib.getExe config.security.gopass.package)
          "show"
          "-o"
          config.communication.senpai.identity.passwordGopassSecret
        ];
      };
    };
  };
}
