{ lib, ... }:

{
	imports = [
		./lf
		./lsd
		./nnn
	];

	options.tools.file-manager = {
		default = lib.mkOption {
			type = lib.types.str;
			description = "Path to the default file manager program.";
		};
	};
}
