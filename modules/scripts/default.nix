{ config, lib, pkgs, ... }:

{
	options.scripts = {
		enable = lib.mkEnableOption "Enable scripts.";
	};

	config = lib.mkIf config.scripts.enable {
		home.file."scripts/restart-network" = {
			source = ./restart-network.sh;
			executable = true;
		};
	};
}
