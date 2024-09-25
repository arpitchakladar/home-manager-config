{ lib, ... }:

{
	imports = [
		./rofi
	];

	options.desktop.popup-manager = {
		application-launcher.default = lib.mkOption {
			type = lib.types.str;
			description = "Path to the default application launcher program.";
		};
	};
}
