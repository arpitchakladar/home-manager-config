{ pkgs, config, lib, ... }:

{
	options.desktop.terminal.kitty = {
		enable = lib.mkEnableOption "Enables kitty.";
	};

	config = lib.mkIf config.desktop.terminal.kitty.enable {
		assertions = [
			{
				assertion = config.desktop.xdg-portal.enable;
				message ="Module desktop.terminal.kitty requires desktop.xdg-portal module to be enabled.";
			}
		];
		programs.kitty.enable = true;
		desktop.terminal.default = lib.mkDefault "${pkgs.kitty}/bin/kitty";

		programs.kitty.settings = with config.scheme.withHashtag; {
			window_padding_width = config.desktop.window-manager.gap;
			font_size = config.fonts.size;
			font_family = config.fonts.normal;
			filter_notification = "all";
			update_check_interval = 0;
			scrollback_indicator_opacity = "0.5";

			dynamic_background_opacity = false;
			allow_remote_control = false;
			enable_audio_bell = false;

			background = base00;
			foreground = base05;

			color0 = base00; # Black
			color1 = base08; # Red
			color2 = base0B; # Green
			color3 = base0A; # Yellow
			color4 = base0D; # Blue
			color5 = base0E; # Magenta
			color6 = base0C; # Cyan
			color7 = base05; # White

			selection_background = base03;
			selection_foreground = base00;

			shell = config.shell.default;
		};
	};
}
