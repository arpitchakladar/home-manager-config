{ lib, config, ... }:

{
	options = {
		xinit.enable = lib.mkEnableOption "Enables xinit.";
	};

	config = lib.mkIf config.xinit.enable {
		home.file.".xinitrc" = {
			source = ./xinitrc;
			executable = true;
		};
	};
}
