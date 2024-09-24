{ pkgs, lib, config, ... }:

{
	options = {
		lsd.enable = lib.mkEnableOption "Enables lsd.";
	};

	config = lib.mkIf config.lsd.enable {
		programs.lsd.enable = true;
		programs.lsd.enableAliases = true;
		programs.bash.shellAliases."tree" = "${pkgs.lsd}/bin/lsd -a --tree";

		programs.lsd.settings = {
			icons.separator = "  ";
		};
	};
}
