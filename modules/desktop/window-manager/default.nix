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
	};
}
