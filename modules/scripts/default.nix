{ config, lib, pkgs, ... }:

{
	options.scripts = {
		enable = lib.mkEnableOption "Enable scripts.";
	};

	config = lib.mkIf config.scripts.enable {
		home.file."scripts" = {
			source = ./scripts;
			recursive = true;
		};

		home.file."scripts/home-manager-switch" = {
			text = ''
#!/bin/sh
home-manager switch --flake ${config.baseDirectory}/#${config.home.username}
			'';
			executable = true;
		};

		home.activation.modifyScripts = lib.mkAfter ''
			for script in ${config.home.homeDirectory}/scripts/*.sh; do
				[ -f "$script" ] && mv "$script" "''${script%.sh}"
			done
			chmod -R u+x ${config.home.homeDirectory}/scripts
		'';
	};
}
