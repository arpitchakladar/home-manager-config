# Distributed version control system
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development.git;
in
{
  imports = [
    ./assertions.nix
  ]
  ++ lib.optional (builtins.pathExists ../../private/git.nix) ../../private/git.nix;

  options.development.git = {
    enable = lib.mkEnableOption "Enables git.";

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.git.package;
      description = "The git package to use.";
    };

    username = lib.mkOption {
      type = lib.types.str;
      description = "Git username.";
    };

    email = lib.mkOption {
      type = lib.types.str;
      description = "Git email.";
    };

    signing = lib.mkOption {
      type = lib.types.submodule {
        options = {
          key = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "GPG key ID used for signing commits.";
          };

          sign-by-default = lib.mkEnableOption "Sign commits by default.";
        };
      };
      default = { };
      description = "Git commit signing configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      signing = {
        key = cfg.signing.key;
        signByDefault = cfg.signing.sign-by-default;
      };
      settings = lib.mkMerge [
        {
          user = {
            name = cfg.username;
            email = cfg.email;
          };
          core = {
            askPass = "";
            logallrefupdates = true;
          };
          log.showSignature = true;
          pull.rebase = true;
          init.defaultBranch = "master";
          merge.ff = false;
        }

        (lib.optionalAttrs config.development.delta.enable {
          core.pager = "delta";
          interactive.diffFilter = "delta --color-only";
          delta.navigate = true;
        })
      ];
    };
  };
}
