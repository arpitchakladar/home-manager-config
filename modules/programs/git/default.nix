{
  config,
  lib,
  pkgs,
  ...
}:

# Git - Distributed version control system
{
  imports = [
    ./assertions.nix
  ]
  ++ lib.optional (builtins.pathExists ../../private/git.nix) ../../private/git.nix;

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
  };

  config = lib.mkIf config.programs.git.enable {
    home.packages = with pkgs; [
      git-graph
    ];

    programs.git = {
      settings =
        lib.recursiveUpdate
          {
            user = {
              name = config.programs.git.username;
              email = config.programs.git.email;
            };
            core.askPass = "";
            alias = {
              # The exclamation mark (!) tells Git to execute this as an external shell command.
              # This overrides standard git-graph behavior with your custom format string.
              log-graph = ''
                !f() {
                  fmt=$(printf '\033[1;34mCommit:\033[0m \033[33m%%h\033[0m%%n\033[1;34mParents:\033[0m \033[35m%%p\033[0m%%n\033[1;34mAuthor:\033[0m \033[32m%%an\033[0m <\033[96m%%ae\033[0m>%%n\033[1;34mDate:\033[0m \033[36m%%ad (%%ar)\033[0m%%n%%n%%B%%n\033[90m--------------------------------------------------------\033[0m')

                  git-graph --color always --sparse --style round --format="$fmt"
                }; f
              '';
            };
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
    };
  };
}
