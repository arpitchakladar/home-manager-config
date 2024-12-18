{ config, pkgs, lib, ... }:

{
	options.tools.file-manager.nnn = {
		enable = lib.mkEnableOption "Enables nnn.";
	};

	config =
	let
		nnnWithNerdIcons = pkgs.nnn.override ({ withNerdIcons = true; });
	in lib.mkIf config.tools.file-manager.nnn.enable {
		tools.file-manager.default = lib.mkDefault "nnn";
		tools.file-manager.command =
			lib.mkIf
				(config.tools.file-manager.default == "nnn")
				"${nnnWithNerdIcons}/bin/nnn -H -d";

		programs.nnn.enable = true;
		programs.nnn.package = nnnWithNerdIcons;
		programs.nnn.plugins.src = "${nnnWithNerdIcons}/share/plugins";
		shell.alias."nnn" = "${nnnWithNerdIcons}/bin/nnn -H -d";
	};
}
