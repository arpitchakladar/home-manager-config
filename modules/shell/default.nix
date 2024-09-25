{ lib, pkgs, ... }:

{
	imports = [
		./bash
		./zsh
	];

	options.shell = {
		default = lib.mkOption {
			type = lib.types.str;
			description = "Path to the default shell program.";
		};
		alias = lib.mkOption {
			type = lib.types.attrs;
			description = "Shell aliases.";
		};
	};

	config = {
		shell.default = lib.mkDefault "${pkgs.bash}/bin/bash"; # Set bash as default shell
		shell.bash.enable = lib.mkDefault true; # Enable bash by default
	};
}
