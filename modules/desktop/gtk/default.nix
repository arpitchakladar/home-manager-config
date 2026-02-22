{ config, lib, pkgs, ... }:

{
	config = lib.mkIf config.desktop.enable {
		home.packages = with pkgs; [
			gnome-themes-extra
			gtk-engine-murrine
			sassc
		];
		gtk = {
			enable = true;
			colorScheme = "dark";
			cursorTheme = {
				package = pkgs.vimix-cursors;
				name = "Vimix";
			};
			theme = {
				package = pkgs.nightfox-gtk-theme.override {
					tweakVariants = [ "carbonfox" ];
				};
				name = "Nightfox-Dark-Carbonfox";
			};
		};
	};
}
