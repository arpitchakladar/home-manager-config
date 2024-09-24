{ config, ... }:

{
	programs.bat.enable = true;
	programs.bat.config.theme = "customTheme";
	xdg.configFile."bat/themes/customTheme.tmTheme".text
		= import ./theme.nix config;
}
