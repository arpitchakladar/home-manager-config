{ lib, ... }:

{
	imports = [
		./rofi
	];

	options.desktop.popup-manager = {
		application-launcher.command = lib.mkOption {
			type = lib.types.str;
			description = "Command for default application launcher program.";
		};
	};
}
