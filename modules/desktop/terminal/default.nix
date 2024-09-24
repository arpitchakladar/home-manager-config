{ lib, ... }:

{
	imports = [
		./alacritty
	];

	options = {
		desktop.terminal.default = lib.mkOption {
			type = lib.types.string;
			description = "Path to the default terminal program.";
		};
	};
}
