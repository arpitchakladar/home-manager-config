{ ... }:

{
	programs.zsh.enable = true;
	programs.zsh.dotDir = ".config/zsh";
	programs.zsh.history.path = "$HOME/.cache/zsh/history";
	programs.zsh.initExtra = builtins.readFile ./zshrc;
}
