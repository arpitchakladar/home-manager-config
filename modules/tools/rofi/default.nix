{ lib, config, ... }:

{
	options.tools.rofi = {
		enable = lib.mkEnableOption "Enables rofi.";
	};

	config = lib.mkIf config.tools.rofi.enable {
		programs.rofi = {
			enable = true;
			font = "${config.fonts.normal} ${toString config.fonts.size}";
			theme =  with config.scheme.withHashtag; let
				inherit (config.lib.formats.rasi) mkLiteral;
			in {
				"*" = {
					border = 1;
					margin = 0;
					padding = 0;
					spacing = 0;

					bg = mkLiteral base00;
					bg-alt = mkLiteral base01;
					fg = mkLiteral base07;
					fg-alt = mkLiteral base03;
					background-color = mkLiteral "@bg";
					text-color = mkLiteral "@fg";
				};

				window = {
					border-color = mkLiteral base03;
				};

				mainbox = {
					children = map mkLiteral [ "inputbar" "listview" ];
				};

				inputbar = {
					background-color = mkLiteral "@bg-alt";
					children = map mkLiteral [ "prompt" "entry" ];
				};

				entry = {
					background-color = mkLiteral "inherit";
					padding = mkLiteral "12px 3px";
				};

				prompt = {
					background-color = mkLiteral "inherit";
					padding = mkLiteral "12px";
				};

				listview = {
					lines = 8;
				};

				element = {
					children = map mkLiteral [ "element-text" ];
				};

				element-icon = {
					padding = mkLiteral "10px 10px";
				};

				element-text = {
					padding = mkLiteral "10px 10px";
					text-color = mkLiteral "@fg-alt";
				};

				"element-text selected" = {
					text-color = mkLiteral "@fg";
				};
			};
		};
	};
}
