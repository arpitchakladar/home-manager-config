{ pkgs, config, lib, ... }:

{
	options.desktop.terminal.alacritty = {
		enable = lib.mkEnableOption "Enables alacritty.";
	};

	config = lib.mkIf config.desktop.terminal.alacritty.enable {
		programs.alacritty.enable = true;
		desktop.terminal.default = lib.mkDefault "alacritty";
		desktop.terminal.command =
			if config.desktop.terminal.default == "alacritty" then
				lib.mkForce "${pkgs.kitty}/bin/alacritty"
			else "";

		programs.alacritty.settings = {
			window = {
				opacity = 1.0;
				padding = {
					x = 4;
					y = 0;
				};
				decorations = "full";
			};

			font = {
				normal = {
					family = config.fonts.normal;
					style = "Retina";
				};
				bold = {
					family = config.fonts.bold;
					style = "Bold";
				};
				italic = {
					family = config.fonts.italic;
				};
				size = config.fonts.size;
			};

			colors = with config.scheme; {
				primary = {
					background = "0x${base00}";
					foreground = "0x${base05}";
				};
				normal = {
					black = "0x${base00}";
					red = "0x${base08}";
					green = "0x${base0B}";
					yellow = "0x${base0A}";
					blue = "0x${base0D}";
					magenta = "0x${base0E}";
					cyan = "0x${base0C}";
					white = "0x${base05}";
				};
				bright = {
					black = "0x${base03}";
					red = "0x${base08}";
					green = "0x${base0B}";
					yellow = "0x${base0A}";
					blue = "0x${base0D}";
					magenta = "0x${base0E}";
					cyan = "0x${base0C}";
					white = "0x${base07}";
				};
				dim = {
					black = "0x${base01}";
					red = "0x${base08}";
					green = "0x${base0B}";
					yellow = "0x${base0A}";
					blue = "0x${base0D}";
					magenta = "0x${base0E}";
					cyan = "0x${base0C}";
					white = "0x${base04}";
				};
			};

			shell = {
				program = config.shell.command;
			};
		};
	};
}
