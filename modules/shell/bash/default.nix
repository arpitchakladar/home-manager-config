{ config, lib, ... }:

{
	options = {
		bash.enable = lib.mkEnableOption "Enables bash.";
	};

	config = lib.mkIf config.bash.enable {
		programs.bash.enable = true;
		programs.bash.historyFile = "${config.xdg.cacheHome}/bash/history";
		home.file."${config.xdg.cacheHome}/bash/histroy".text = ""; # Create the cache directory and histroy file
	};
}
