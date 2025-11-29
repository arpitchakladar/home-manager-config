{ pkgs, config, lib, ... }:

{
	options.tools.kitty = {
		enable = lib.mkEnableOption "Enables kitty. WARNING! Currently faces problems with color rendering with picom.";
	};

	config = lib.mkIf config.tools.kitty.enable {
		programs.kitty = {
			enable = true;
			settings = with config.scheme.withHashtag; {
				window_padding_width = 10;
				font_size = config.fonts.size;
				font_family = config.fonts.normal;
				filter_notification = "all";
				update_check_interval = 0;
				scrollback_indicator_opacity = "0.5";

				dynamic_background_opacity = false;
				enable_audio_bell = false;

				background = base00;
				foreground = base05;

				color0  = base00;
				color1  = base08;
				color2  = base0B;
				color3  = base0A;
				color4  = base0D;
				color5  = base0E;
				color6  = base0C;
				color7  = base05;
				color8  = base03;
				color9  = base09;
				color10 = base0B;
				color11 = base0A;
				color12 = base0D;
				color13 = base0E;
				color14 = base0F;
				color15 = base07;

				selection_background = base05;
				selection_foreground = base00;

				allow_remote_control = "yes";
				listen_on = "unix:/tmp/kitty";
				shell = lib.mkIf config.tools.zsh.enable "zsh";
			};
		};
	};
}
