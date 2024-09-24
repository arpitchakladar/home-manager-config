{ config, lib, ... }:

{
	options.tools.viewer.bat = {
		enable = lib.mkEnableOption "Enables bat.";
	};

	config = lib.mkIf config.tools.viewer.bat.enable {
		programs.bat.enable = true;
		programs.bat.config.theme = "customTheme";
		xdg.configFile."bat/themes/customTheme.tmTheme".text
			= import ./theme.nix config;
	};
}
