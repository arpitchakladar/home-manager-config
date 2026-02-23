{ config, lib, pkgs, ... }:

{
	config = lib.mkIf config.desktop.enable {
		gtk = {
			enable = true;
			colorScheme = "dark";
			theme = {
				package = pkgs.nightfox-gtk-theme.override {
					tweakVariants = [ "carbonfox" ];
				};
				name = "Nightfox-Dark-Carbonfox";
			};
		};
	};
}
