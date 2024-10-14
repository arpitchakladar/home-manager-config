{ lib, config, ... }:

{
	imports = [
		./nerdfont
	];

	options.fonts = {
		normal = lib.mkOption {
			type = lib.types.str;
			description = "Default normal font name.";
		};

		bold = lib.mkOption {
			type = lib.types.str;
			description = "Default bold font name.";
			default = config.fonts.normal;
		};

		italic = lib.mkOption {
			type = lib.types.str;
			description = "Default italic font name.";
			default = config.fonts.normal;
		};

		size = lib.mkOption {
			type = lib.types.int;
			description = "Default font size.";
			default = 16;
		};
	};
}
