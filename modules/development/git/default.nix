# Distributed version control system
{
  config,
  lib,
  ...
}:
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

    signing = {
      key = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "GPG key ID used for signing commits.";
      };

      signByDefault = lib.mkEnableOption "Sign commits by default.";
    };
  };

  config = lib.mkIf config.development.git.enable {
    programs.git = {
      enable = true;
      signing = {
        key = config.development.git.signing.key;
        signByDefault = config.development.git.signing.signByDefault;
      };
      settings = lib.mkMerge [
        {
          user = {
            name = config.development.git.username;
            email = config.development.git.email;
          };
          core = {
            askPass = "";
            logallrefupdates = true;
          };
          log.showSignature = true;
          pull.rebase = true;
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
