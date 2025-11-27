{ config, lib, pkgs, ... }:

{
	options.scripts = {
		enable = lib.mkEnableOption "Enable scripts.";
	};

	config = lib.mkIf config.scripts.enable {
		home.sessionPath = [
			"${config.home.homeDirectory}/scripts"
		];

		home.file."scripts/restart-network" = {
			source = ./restart-network.sh;
			executable = true;
		};
	};
}
