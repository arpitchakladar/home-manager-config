{ pkgs, lib, config, ... }:

{
	options.tools.file-manager.lsd = {
		enable = lib.mkEnableOption "Enables lsd.";
	};

	config = lib.mkIf config.tools.file-manager.lsd.enable {
		programs.lsd.enable = true;
		programs.lsd.enableAliases = true;
		shell.alias."tree" = "${pkgs.lsd}/bin/lsd -a --tree";

		programs.lsd.settings = {
			icons.separator = "  ";
		};
	};
}
