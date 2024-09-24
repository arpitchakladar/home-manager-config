{ lib, config, ... }:

{
	options = {
		desktop.display-server.x11.xinit.enable = lib.mkEnableOption "Enables xinit.";
	};

	config = lib.mkIf config.desktop.display-server.x11.xinit.enable {
		home.file.".xinitrc" = {
			source = ./xinitrc;
			executable = true;
		};
	};
}
