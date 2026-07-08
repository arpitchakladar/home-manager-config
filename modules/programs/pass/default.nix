{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.pass;
  githubMapping = ''
    [github.com]
    target = github/token
    username = ${cfg.github.username}
    username_extractor = static

    [github.com/*]
    target = github/token
    username = ${cfg.github.username}
    username_extractor = static

    [*.github.com]
    target = github/token
    username = ${cfg.github.username}
    username_extractor = static

    [*.github.com/*]
    target = github/token
    username = ${cfg.github.username}
    username_extractor = static
  '';
in
{
  options.programs.pass = {
    enable = lib.mkEnableOption "pass password manager";

    package = lib.mkPackageOption pkgs "pass" { };

    storeDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.password-store";
      description = "Path to the pass password store.";
    };

    github = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "x-access-token";
        description = "Username returned to Git for GitHub HTTPS credentials.";
      };

      tokenEntry = lib.mkOption {
        type = lib.types.str;
        default = "github/token";
        description = "Pass entry containing the GitHub token on its first line.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.password-store = {
      enable = true;
      package = cfg.package;
      settings = {
        PASSWORD_STORE_DIR = cfg.storeDir;
      };
    };

    home.file.".config/pass-git-helper/git-pass-mapping.ini".text = githubMapping;
  };
}
