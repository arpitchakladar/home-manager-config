# Zsh - Z shell, extended bash with additional features and plugins
{
  config,
  lib,
  ...
}:
{
  options.terminal.zsh = {
    enable = lib.mkEnableOption "Enables zsh.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.zsh.package;
      description = "The zsh package to use.";
    };
  };

  config =
    let
      nixCommandWrappers = builtins.readFile ./nix-aliases.sh;
    in
    lib.mkIf config.terminal.zsh.enable {
      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
        history.path = "${config.xdg.cacheHome}/zsh/history";
        enableCompletion = true;
        initContent = ''
          setopt PROMPT_SUBST

          # Vi insert/command modes for command-line editing. Escape enters normal mode.
          bindkey -v
          KEYTIMEOUT=1

          autoload -U colors && colors

          export GPG_TTY="$(tty)"
          gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1

          bindkey "^[[3~" delete-char
          bindkey "^?" backward-delete-char
          ${nixCommandWrappers}
        '';
      };

      programs.bash.initExtra = lib.mkIf config.terminal.bash.enable (lib.mkAfter nixCommandWrappers);

      home.sessionVariables.SHELL = "${lib.getExe config.terminal.zsh.package}";
    };
}
