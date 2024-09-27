{ lib, ... }:

{
	imports = [
		./bspwm
		./sxhkd
	];

	options.desktop.window-manager = {
		default = lib.mkOption {
			type = lib.types.str;
			description = "Path to the default window manager program.";
		};

		gap = lib.mkOption {
			type = lib.types.int;
			default = 5;
			description = "The spacing between windows.";
		};
	};
}
