{ config, lib, pkgs, ... }:

{
	options.desktop.popup-manager.rofi = {
		enable = lib.mkEnableOption "Enables rofi.";
	};

	config = lib.mkIf config.desktop.popup-manager.rofi.enable {
		desktop.popup-manager.application-launcher.default = "${pkgs.rofi}/bin/rofi -show run";
		programs.rofi.enable = true;
		programs.rofi.font = "FiraCode Nerd Font 16";
		programs.rofi.theme = config.scheme {
			template = builtins.readFile ./theme.rasi.mustache;
		};
	};
}
