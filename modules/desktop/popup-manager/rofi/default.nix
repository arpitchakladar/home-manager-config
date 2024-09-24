{ config, lib, ... }:

{
	options.desktop.popup-manager.rofi = {
		enable = lib.mkEnableOption "Enables rofi.";
	};

	config = lib.mkIf config.desktop.popup-manager.rofi.enable {
		programs.rofi.enable = true;
		programs.rofi.font = "FiraCode Nerd Font 16";
		programs.rofi.theme = import ./theme config;
	};
}
