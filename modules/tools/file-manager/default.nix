{ lib, ... }:

{
	imports = [
		./lf
		./lsd
		./nnn
	];

	options.tools.file-manager = {
		default = lib.mkOption {
			type = lib.types.enum [
				"nnn"
				"lf"
			];
			description = "Default file manager.";
		};

		command = lib.mkOption {
			type = lib.types.str;
			description = "Command for the default file manager program.";
		};
	};
}
