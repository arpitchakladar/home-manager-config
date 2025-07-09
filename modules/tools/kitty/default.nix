{ pkgs, config, lib, ... }:

{
	options.tools.kitty = {
		enable = lib.mkEnableOption "Enables kitty. WARNING! Currently faces problems with color rendering with picom.";
	};

	config = lib.mkIf config.tools.kitty.enable {
		programs.kitty.enable = true;
		programs.kitty.settings = with config.scheme.withHashtag; {
			window_padding_width = 10;
			font_size = config.fonts.size;
			font_family = config.fonts.normal;
			filter_notification = "all";
			update_check_interval = 0; # disable notifications
			scrollback_indicator_opacity = "0.5";

			dynamic_background_opacity = false;
			allow_remote_control = false;
			enable_audio_bell = false;

			background = base00;
			foreground = base05;
			text_composition_strategy = "legacy";

			color0 = base00; # Black
			color8 = base00; # Black
			color1 = base08; # Red
			color9 = base08; # Red
			color2 = base0B; # Green
			color10 = base0B; # Green
			color3 = base0A; # Yellow
			color11 = base0A; # Yellow
			color4 = base0D; # Blue
			color12 = base0D; # Blue
			color5 = base0E; # Magenta
			color13 = base0E; # Magenta
			color6 = base0C; # Cyan
			color14 = base0C; # Cyan
			color7 = base05; # White
			color15 = base05; # White

			selection_background = base03;
			selection_foreground = base00;
		};
	};
}
