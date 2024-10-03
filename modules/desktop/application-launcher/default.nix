{ lib, ... }:

{
	imports = [
		./fzf
		./rofi
	];

	options.desktop.application-launcher = {
		default = lib.mkOption {
			type = lib.types.enum [
				"fzf"
				"rofi"
			];

			description = "Select the default application launcher.";
		};

		command = lib.mkOption {
			type = lib.types.str;
			description = "Command for default application launcher program.";
		};
	};
}
