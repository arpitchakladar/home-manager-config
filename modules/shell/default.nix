{ lib, pkgs, ... }:

{
	imports = [
		./bash
		./zsh
	];

	options.shell = {
		default = lib.mkOption {
			type = lib.types.enum [
				"bash"
				"zsh"
			];
			description = "Default shell.";
		};

		command = lib.mkOption {
			type = lib.types.str;
			description = "Command for the default shell.";
		};

		alias = lib.mkOption {
			type = lib.types.attrs;
			description = "Shell aliases.";
		};
	};
}
