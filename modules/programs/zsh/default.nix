{
  config,
  lib,
  pkgs,
  ...
}:

# Zsh - Z shell, extended bash with additional features and plugins
{
  config =
    let
      nixCommandWrappers = builtins.readFile ./nix-aliases.sh;
    in
    lib.mkIf config.programs.zsh.enable {
      programs.zsh = {
        package = pkgs.zsh;
        dotDir = "${config.xdg.configHome}/zsh";
        history.path = "${config.xdg.cacheHome}/zsh/history";
        enableCompletion = true;
        initContent = ''
          setopt PROMPT_SUBST

          autoload -U colors && colors

          export GPG_TTY="$(tty)"
          gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1

          bindkey "^[[3~" delete-char
          bindkey "^?" backward-delete-char
          ${nixCommandWrappers}
        '';
      };

      programs.bash.initExtra = lib.mkIf config.programs.bash.enable (lib.mkAfter nixCommandWrappers);

      home.sessionVariables.SHELL = "${lib.getExe config.programs.zsh.package}";
    };
}
