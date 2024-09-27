{ config, pkgs, lib, ... }:

{
	options.tools.file-manager.nnn = {
		enable = lib.mkEnableOption "Enables nnn.";
	};

	config = lib.mkIf config.tools.file-manager.nnn.enable {
		tools.file-manager.default = lib.mkDefault "nnn";
		tools.file-manager.command =
			if config.tools.file-manager.default == "nnn" then
				lib.mkForce "${pkgs.nnn}/bin/nnn -H -d"
			else "";

		programs.nnn.enable = true;
		programs.nnn.package = pkgs.nnn.override ({ withNerdIcons = true; });
		programs.nnn.plugins.src = "${pkgs.nnn}/share/plugins";
		shell.alias."nnn" = "nnn -H -d";
	};
}
