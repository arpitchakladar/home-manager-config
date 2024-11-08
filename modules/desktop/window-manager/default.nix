{ lib, ... }:

{
	imports = [
		./bspwm
		./i3
		./sxhkd
	];

	options.desktop.window-manager = {
		default = lib.mkOption {
			type = lib.types.enum [
				"bspwm"
				"i3"
			];
			description = "Default window manager.";
		};

		command = lib.mkOption {
			type = lib.types.str;
			description = "Command window manager program.";
		};

		gap = lib.mkOption {
			type = lib.types.int;
			default = 10;
			description = "The spacing between windows.";
		};
	};
}
