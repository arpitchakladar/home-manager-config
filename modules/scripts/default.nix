{ config, lib, pkgs, ... }:

{
	options.scripts = {
		enable = lib.mkEnableOption "Enable scripts.";
	};

	config = lib.mkIf config.scripts.enable {
		home.file."scripts/restart-network" = {
			source = ./scripts/restart-network.sh;
			executable = true;
		};

		home.file."scripts/home-manager-switch" = {
			text = ''
#!/bin/sh
home-manager switch --flake ${config.baseDirectory}/#${config.home.username}
			'';
			executable = true;
		};
	};
}
