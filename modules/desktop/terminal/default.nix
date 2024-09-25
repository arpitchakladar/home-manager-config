{ lib, ... }:

{
	imports = [
		./alacritty
	];

	options.desktop.terminal = {
		default = lib.mkOption {
			type = lib.types.str;
			description = "Path to the default terminal program.";
		};
	};
}
