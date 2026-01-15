{ config, lib, ... }:

{
	options.tools.zsh = {
		enable = lib.mkEnableOption "Enables zsh.";
	};

	config = lib.mkIf config.tools.zsh.enable {
		programs.zsh = {
			enable = true;
			dotDir = "${config.xdg.configHome}/zsh";
			history.path = "${config.xdg.cacheHome}/zsh/history";
			initContent = ''
${if config.tools.fzf.enable then
	"eval \"$(fzf --zsh)\""
else ""}
${builtins.readFile ./zshrc}
			'';
		};

		home.sessionVariables.SHELL = "${config.programs.zsh.package}/bin/zsh";
	};
}
