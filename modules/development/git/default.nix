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
    home.packages = with pkgs; [
      git-graph
      gawk
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
      unknown = ['bright_white', 'bright_red', 'bright_green', 'bright_yellow', 'bright_blue', 'bright_magenta', 'bright_cyan']

      [svg_colors]
      matches = [
        ['^(master|main|trunk)$', ['blue']],
        ['^(develop|dev)$', ['orange']],
        ['^(feature|fork/).*$', ['magenta', 'cyan']],
        ['^release.*$', ['green']],
        ['^(bugfix|hotfix).*$', ['red']],
        ['^tags/.*$', ['gray', 'purple', 'teal', 'brown']]
      ]
      unknown = ['gray', 'purple', 'teal', 'brown']
    '';

    programs.git = {
      enable = true;
      signing = {
        key = config.development.git.signing.key;
        signByDefault = config.development.git.signing.signByDefault;
      };
      settings =
        lib.recursiveUpdate
          {
            user = {
              name = config.development.git.username;
              email = config.development.git.email;
            };
            core.askPass = "";
            alias = {
              log-graph = ''
                !f() {
                  fmt=$(printf '\033[1;34mCommit:\033[0m \033[33m%%h\033[0m \033[91m%%d\033[0m%%n\x01%%H\x01%%n\033[1;34mParents:\033[0m \033[35m%%p\033[0m%%n\033[1;34mAuthor:\033[0m \033[32m%%an\033[0m <\033[96m%%ae\033[0m>%%n\033[1;34mDate:\033[0m \033[36m%%ad (%%ar)\033[0m%%n%%n%%B%%n\033[90m--------------------------------------------------------\033[0m')
                  git-graph --model custom --color always --sparse --style round --format="$fmt" | awk '
                    index($0, "\x01") > 0 {
                      line  = $0
                      start = index(line, "\x01")
                      rest  = substr(line, start + 1)
                      stop  = index(rest, "\x01")
                      hash   = substr(rest, 1, stop - 1)
                      prefix = substr(line, 1, start - 1)

                      gsub(/\033\[[0-9;]*[a-zA-Z]/, "", hash)
                      gsub(/[^0-9a-fA-F]/, "", hash)

                      if (length(hash) >= 7) {
                        cmd = "git log -1 --format=\"%G?|%GK\" " hash " 2>/dev/null"
                        cmd | getline sig
                        close(cmd)
                        split(sig, a, "|")
                        st = a[1]; key = a[2]
                      } else {
                        st = ""; key = ""
                      }

                      if      (st == "G") label = "\033[32mgood\033[0m"
                      else if (st == "B") label = "\033[31mbad\033[0m"
                      else if (st == "U") label = "\033[33muntrusted\033[0m"
                      else if (st == "X") label = "\033[33mexpired sig\033[0m"
                      else if (st == "Y") label = "\033[33mexpired key\033[0m"
                      else if (st == "R") label = "\033[31mrevoked\033[0m"
                      else if (st == "E") label = "\033[90munverifiable\033[0m"
                      else                label = "\033[90mnone\033[0m"
                      keydisp = (key == "") ? "\033[90m-\033[0m" : "\033[35m" key "\033[0m"
                      printf "%s\033[1;34mSignature:\033[0m %s %s\n", prefix, label, keydisp
                      next
                    }
                    { print }
                  '
                }; f | less -R
              '';
              log-graph-embed = ''
                !f() {
                  fmt=$(printf '\033[1;34mCommit:\033[0m \033[33m%%h\033[0m \033[91m%%d\033[0m%%n\x01%%H\x01%%n\033[1;34mParents:\033[0m \033[35m%%p\033[0m%%n\033[1;34mAuthor:\033[0m \033[32m%%an\033[0m <\033[96m%%ae\033[0m>%%n\033[1;34mDate:\033[0m \033[36m%%ad (%%ar)\033[0m%%n%%n%%B%%n\033[90m--------------------------------------------------------\033[0m')
                  git-graph --model custom --color always --sparse --style round --no-pager --format="$fmt" | awk '
                    index($0, "\x01") > 0 {
                      line  = $0
                      start = index(line, "\x01")
                      rest  = substr(line, start + 1)
                      stop  = index(rest, "\x01")
                      hash   = substr(rest, 1, stop - 1)
                      prefix = substr(line, 1, start - 1)

                      gsub(/\033\[[0-9;]*[a-zA-Z]/, "", hash)
                      gsub(/[^0-9a-fA-F]/, "", hash)

                      if (length(hash) >= 7) {
                        cmd = "git log -1 --format=\"%G?|%GK\" " hash " 2>/dev/null"
                        cmd | getline sig
                        close(cmd)
                        split(sig, a, "|")
                        st = a[1]; key = a[2]
                      } else {
                        st = ""; key = ""
                      }

                      if      (st == "G") label = "\033[32mgood\033[0m"
                      else if (st == "B") label = "\033[31mbad\033[0m"
                      else if (st == "U") label = "\033[33muntrusted\033[0m"
                      else if (st == "X") label = "\033[33mexpired sig\033[0m"
                      else if (st == "Y") label = "\033[33mexpired key\033[0m"
                      else if (st == "R") label = "\033[31mrevoked\033[0m"
                      else if (st == "E") label = "\033[90munverifiable\033[0m"
                      else                label = "\033[90mnone\033[0m"
                      keydisp = (key == "") ? "\033[90m-\033[0m" : "\033[35m" key "\033[0m"
                      printf "%s\033[1;34mSignature:\033[0m %s %s\n", prefix, label, keydisp
                      next
                    }
                    { print }
                  '
                }; f
              '';
            };
          }
          (
            lib.optionalAttrs config.development.git.useSSH {
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
