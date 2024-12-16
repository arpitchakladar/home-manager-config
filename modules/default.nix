{ lib, ... }:

{
	imports = [
		./desktop
		./fonts
		./scripts
		./shell
		./tools
	];

	options = {
		baseDirectory = lib.mkOption {
			type = lib.types.str;
			description = "Path to the base of the current home manager configuration.";
		};
	};
}
