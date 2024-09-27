{ lib, ... }:

{
	imports = [
		./alacritty
		./kitty
	];

	options.desktop.terminal = {
		command = lib.mkOption {
			type = lib.types.str;
			description = "Command for the terminal.";
		};

		default = lib.mkOption {
			type = lib.types.enum [
				"kitty"
				"alacritty"
			];
			description = "Default terminal.";
		};
	};
}
