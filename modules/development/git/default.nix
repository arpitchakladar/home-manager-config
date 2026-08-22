# Distributed version control system
{
  config,
  lib,
  pkgs,
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

    useSSH = lib.mkEnableOption "Use SSH instead of HTTPS for common git platforms.";

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
        }

        (lib.optionalAttrs config.development.git.useSSH {
          url."git@github.com:".insteadOf = "https://github.com/";
          url."git@gitlab.com:".insteadOf = "https://gitlab.com/";
          url."git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
          url."git@codeberg.org:".insteadOf = "https://codeberg.org/";
          url."git@git.sr.ht:".insteadOf = "https://git.sr.ht/";
        })

        (lib.optionalAttrs config.development.git.enable {
          core.pager = "delta";
          interactive.diffFilter = "delta --color-only";
          delta.navigate = true;
        })
      ];
    };
  };
}
