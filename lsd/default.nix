{ pkgs, ... }:

{
	programs.lsd.enable = true;
	programs.lsd.enableAliases = true;
	programs.bash.shellAliases."tree" = "${pkgs.lsd}/bin/lsd -a --tree";

	programs.lsd.settings = {
		icons.separator = "  ";
	};
}
