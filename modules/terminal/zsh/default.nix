{
  config,
  lib,
  pkgs,
  ...
}:

# Zsh - Z shell, extended bash with additional features and plugins
{
  options.terminal.zsh = {
    enable = lib.mkEnableOption "Enables zsh.";
    package = lib.mkPackageOption pkgs "zsh" { };
  };

  config =
    let
      nixCommandWrappers = builtins.readFile ./nix-aliases.sh;
    in
    lib.mkIf config.terminal.zsh.enable {
      programs.zsh = {
        enable = true;
        package = config.terminal.zsh.package;
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

      programs.bash.initExtra = lib.mkIf config.terminal.bash.enable (lib.mkAfter nixCommandWrappers);

      home.sessionVariables.SHELL = "${lib.getExe config.terminal.zsh.package}";
    };
}
