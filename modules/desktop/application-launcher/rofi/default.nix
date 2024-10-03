{ config, lib, pkgs, ... }:

{
	options.desktop.application-launcher.rofi = {
		enable = lib.mkEnableOption "Enables rofi.";
	};

	config = lib.mkIf config.desktop.application-launcher.rofi.enable {
		desktop.application-launcher.default = lib.mkDefault "rofi";
		desktop.application-launcher.command =
			if config.desktop.application-launcher.default == "rofi" then
				lib.mkForce "${pkgs.rofi}/bin/rofi -show run"
			else "";
		programs.rofi.enable = true;
		programs.rofi.font = "${config.fonts.normal} ${toString config.fonts.size}";
		programs.rofi.theme = config.scheme {
			template = builtins.readFile ./theme.mustache.rasi;
		};
	};
}
