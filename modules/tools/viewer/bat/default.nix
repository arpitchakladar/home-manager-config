{ config, lib, pkgs, ... }:

{
	options.tools.viewer.bat = {
		enable = lib.mkEnableOption "Enables bat.";
	};

	config = lib.mkIf config.tools.viewer.bat.enable {
		programs.bat.enable = true;
		programs.bat.config = {
			tabs = "4";
			theme = "custom-theme";
		};
		shell.alias."bc" = "${pkgs.bat}/bin/bat -pp";
		shell.alias."bp" = "${pkgs.bat}/bin/bat --paging always";
		home.sessionVariables."PAGER" = "${pkgs.bat}/bin/bat --paging always";
		xdg.configFile."bat/themes/custom-theme.tmTheme".source
			= config.scheme {
				template = builtins.readFile ./theme.mustache.tmTheme;
			};
	};
}
