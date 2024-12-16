{ config, lib, pkgs, ... }:

{
	options.shell.bash = {
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enables bash.";
			default = true;
		};
	};

	config = lib.mkIf config.shell.bash.enable {
		shell.default = lib.mkDefault "bash";
		shell.command =
			lib.mkIf
				(config.shell.default == "bash")
				"${pkgs.zsh}/bin/bash";

		programs.bash.enable = true;
		programs.bash.historyFile = "${config.xdg.cacheHome}/bash/history";
		programs.bash.shellAliases = config.shell.alias;
		programs.bash.bashrcExtra = ''
${if config.tools.utils.fzf.enable then
	"eval \"$(fzf --bash)\""
else ""}
${if config.scripts.enable then
	"export PATH=${config.home.homeDirectory}/scripts:$PATH"
else ""}
		'';

		home.activation.createBashCacheDirectory =
			lib.hm.dag.entryAfter
				[ "writeBoundary" ]
				"mkdir -p ${config.xdg.cacheHome}/bash";
	};
}
