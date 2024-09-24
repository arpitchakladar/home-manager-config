{ config, lib, pkgs, ... }:

{
	options.shell.bash = {
		enable = lib.mkEnableOption "Enables bash.";
	};

	config = lib.mkIf config.shell.bash.enable {
		programs.bash.enable = true;
		programs.bash.historyFile = "${config.xdg.cacheHome}/bash/history";
		programs.bash.shellAliases = config.shell.alias;
		home.file."${config.xdg.cacheHome}/bash/histroy".text = ""; # Create the cache directory and histroy file
	};
}
