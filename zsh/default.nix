{ ... }:

{
	programs.zsh = {
		enable = true;
		dotDir = ".config/zsh";
		history.path = "$HOME/.cache/zsh/history";
		initExtra = builtins.readFile ./zshrc;
	};
}
