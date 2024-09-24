{ lib, config, ... }:

{
	imports = [
		./popup-manager
		./status-bar
		./terminal
		./window-manager
		./xresources
	];
}
