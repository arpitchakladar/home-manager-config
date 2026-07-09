{
  config,
  lib,
  ...
}:

# Git - Distributed version control system
{
  imports = [ ./assertions.nix ];

  options.programs.git = {
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
        description = "GPG signing key ID.";
      };
      signByDefault = lib.mkEnableOption "Sign commits by default";
    };
  };

  config = lib.mkIf config.programs.git.enable {
    programs.git = {
      includes = [
        {
          path = "${config.xdg.configHome}/git/personal";
          condition = "hasconfig:remote.*.url:git@*";
        }
      ];
      settings =
        lib.recursiveUpdate
          {
            user = {
              name = config.programs.git.username;
              email = config.programs.git.email;
            };
            core.askPass = "";
          }
          (
            lib.optionalAttrs config.programs.git.useSSH {
              url."git@github.com:".insteadOf = "https://github.com/";
              url."git@gitlab.com:".insteadOf = "https://gitlab.com/";
              url."git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
              url."git@codeberg.org:".insteadOf = "https://codeberg.org/";
              url."git@git.sr.ht:".insteadOf = "https://git.sr.ht/";
            }
          );
      extraConfig = {
        user.signingKey = lib.mkIf (
          config.programs.git.signing.key != null
        ) config.programs.git.signing.key;
        commit.gpgSign = config.programs.git.signing.signByDefault;
        tag.forceSignAnnotated = config.programs.git.signing.signByDefault;
      };
    };
  };
}
