{ config, ... }:

{
	programs.zsh.enable = true;
	programs.zsh.dotDir = ".config/zsh";
	programs.zsh.history.path = "${config.xdg.cacheHome}/zsh/history";
	programs.zsh.initExtra = builtins.readFile ./zshrc;
	programs.zsh.shellAliases = config.programs.bash.shellAliases;
}
