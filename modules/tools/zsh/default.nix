{ config, lib, pkgs, ... }:

{
	options.tools.zsh = {
		enable = lib.mkEnableOption "Enables zsh.";
	};

	config = lib.mkIf config.tools.zsh.enable {
		programs.zsh.enable = true;
		programs.zsh.dotDir = ".config/zsh";
		programs.zsh.history.path = "${config.xdg.cacheHome}/zsh/history";
		programs.zsh.initContent = ''
${if config.tools.fzf.enable then
	"eval \"$(fzf --zsh)\""
else ""}
${builtins.readFile ./zshrc}
		'';
		programs.kitty.settings.shell = lib.mkIf config.tools.kitty.enable "zsh";
	};
}
