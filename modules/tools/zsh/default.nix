{ config, lib, ... }:

{
  options.tools.zsh = {
    enable = lib.mkEnableOption "Enables zsh.";
  };

  config = let
    nixCommandWrappers = builtins.readFile ./nix-aliases.sh;
  in lib.mkIf config.tools.zsh.enable {
    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      history.path = "${config.xdg.cacheHome}/zsh/history";
      enableCompletion = true;
      initContent = ''
        setopt PROMPT_SUBST

        autoload -U colors && colors

        bindkey "^[[3~" delete-char
        bindkey "^?" backward-delete-char
        ${nixCommandWrappers}
      '';
    };

    programs.bash.initExtra = lib.mkIf config.programs.bash.enable
      (lib.mkAfter nixCommandWrappers);

    home.sessionVariables.SHELL = "${config.programs.zsh.package}/bin/zsh";
  };
}
