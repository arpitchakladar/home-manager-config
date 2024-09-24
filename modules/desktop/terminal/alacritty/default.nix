{ pkgs, config, lib, ... }:

{
	options = {
		alacritty.enable = lib.mkEnableOption "Enables alacritty.";
	};

	config = lib.mkIf config.alacritty.enable {
		programs.alacritty.enable = true;

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
					family = "Fira Code Nerd Font";
					style = "Retina";
				};
				bold = {
					family = "Fira Code Nerd Font";
					style = "Bold";
				};
				italic = {
					family = "Fira Code Nerd Font";
				};
				size = 16.0;
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
				program = "${pkgs.zsh}/bin/zsh";
			};
		};
	};
}
