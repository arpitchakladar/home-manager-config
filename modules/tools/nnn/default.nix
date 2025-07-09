{ config, pkgs, lib, ... }:

{
	options.tools.nnn = {
		enable = lib.mkEnableOption "Enables nnn.";
	};

	config =
	let
		nnnWithNerdIcons = pkgs.nnn.override ({ withNerdIcons = true; });
	in lib.mkIf config.tools.nnn.enable {
		programs.nnn.enable = true;
		programs.nnn.package = nnnWithNerdIcons;
		programs.nnn.plugins.src = "${nnnWithNerdIcons}/share/plugins";
	};
}
