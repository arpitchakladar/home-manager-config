{ config, ... }:

{
	programs.bash.enable = true;
	programs.bash.historyFile = "${config.xdg.cacheHome}/bash/history";
	home.file."${config.xdg.cacheHome}/bash/histroy".text = ""; # Create the cache directory and histroy file
}
