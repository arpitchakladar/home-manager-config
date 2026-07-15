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

    xdg.configFile."git-graph/models/custom.toml".text = ''
      persistence = [
        '^(master|main|trunk)$',
        '^(develop|dev)$',
        '^feature.*$',
        '^release.*$',
        '^hotfix.*$',
        '^bugfix.*$',
      ]

      order = [
        '^(master|main|trunk)$',
        '^(hotfix|release).*$',
        '^(develop|dev)$',
      ]

      [terminal_colors]
      matches = [
        ['^(master|main|trunk)$', ['bright_blue']],
        ['^(develop|dev)$', ['bright_yellow']],
        ['^(feature|fork/).*$', ['bright_magenta', 'bright_cyan']],
        ['^release.*$', ['bright_green']],
        ['^(bugfix|hotfix).*$', ['bright_red']],
        ['^tags/.*$', ['bright_green']],
      ]
      # Everything else (e.g. custom/service branches) cycles through these instead of all being white
      unknown = ['bright_white', 'bright_red', 'bright_green', 'bright_yellow', 'bright_blue', 'bright_magenta', 'bright_cyan']

      [svg_colors]
      matches = [
        ['^(master|main|trunk)$', ['blue']],
        ['^(develop|dev)$', ['orange']],
        ['^(feature|fork/).*$', ['magenta', 'cyan']],
        ['^release.*$', ['green']],
        ['^(bugfix|hotfix).*$', ['red']],
        ['^tags/.*$', ['green']],
      ]
      unknown = ['gray', 'purple', 'teal', 'brown']
    '';

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
                  fmt=$(printf '\033[1;34mCommit:\033[0m \033[33m%%h\033[0m \033[91m%%d\033[0m%%n\033[1;34mParents:\033[0m \033[35m%%p\033[0m%%n\033[1;34mAuthor:\033[0m \033[32m%%an\033[0m <\033[96m%%ae\033[0m>%%n\033[1;34mDate:\033[0m \033[36m%%ad (%%ar)\033[0m%%n%%n%%B%%n\033[90m--------------------------------------------------------\033[0m')
                  git-graph --model custom --color always --sparse --style round --format="$fmt"
                }; f | less -R
              '';
              # Same formatting, but no pager — meant for embedding (lazygit, etc.)
              log-graph-embed = ''
                !f() {
                  fmt=$(printf '\033[1;34mCommit:\033[0m \033[33m%%h\033[0m \033[91m%%d\033[0m%%n\033[1;34mParents:\033[0m \033[35m%%p\033[0m%%n\033[1;34mAuthor:\033[0m \033[32m%%an\033[0m <\033[96m%%ae\033[0m>%%n\033[1;34mDate:\033[0m \033[36m%%ad (%%ar)\033[0m%%n%%n%%B%%n\033[90m--------------------------------------------------------\033[0m')
                  git-graph --model custom --color always --sparse --style round --no-pager --format="$fmt"
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
