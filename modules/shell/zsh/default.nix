{ config, lib, pkgs, ... }:

{
	options.shell.zsh = {
		enable = lib.mkEnableOption "Enables zsh.";
	};

	config = lib.mkIf config.shell.zsh.enable {
		shell.default = lib.mkDefault "zsh";
		shell.command =
			if config.shell.default == "zsh" then
				lib.mkForce "${pkgs.zsh}/bin/zsh"
			else "";

		programs.zsh.enable = true;
		programs.zsh.dotDir = ".config/zsh";
		programs.zsh.history.path = "${config.xdg.cacheHome}/zsh/history";
		programs.zsh.shellAliases = config.shell.alias;
		programs.zsh.initExtra = ''
${if config.tools.utils.fzf.enable then
	"eval \"$(fzf --zsh)\""
else ""}
${builtins.readFile ./zshrc}
		'';
	};
}
