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
			if config.shell.default == "bash" then
				lib.mkForce "${pkgs.zsh}/bin/bash"
			else "";

		programs.bash.enable = true;
		programs.bash.historyFile = "${config.xdg.cacheHome}/bash/history";
		programs.bash.shellAliases = config.shell.alias;

		home.activation.createBashCacheDirectory
			= lib.hm.dag.entryAfter
				[ "writeBoundary" ]
				"mkdir -p ${config.xdg.cacheHome}/bash";
	};
}
