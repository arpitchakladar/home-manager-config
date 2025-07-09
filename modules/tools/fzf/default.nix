{ config, lib,... }:

{
	options.tools.fzf = {
		enable = lib.mkEnableOption "Enables fzf.";
	};

	config = lib.mkIf config.tools.fzf.enable {
		programs.fzf.enable = true;
		programs.fzf.defaultOptions = [
			"--height 100%"
			"--layout=reverse"
			''--pointer=\"${if config.fonts.nerdfont.fira-code.enable then " " else ">"}\"''
			''--header=\" \"''
			''--prompt=\" \"''
			''--marker=\"✓ \"''
			"--border=none"
			"--cycle"
			"--no-info"
			"--margin=\"1,2\""
		];

		programs.fzf.colors = with config.scheme.withHashtag; {
			fg = base05; # Foreground
			bg = "-1"; # Background (-1 for transparent)
			hl = base0D; # Highlight

			"fg+" = base07; # Foreground for selected item
			"bg+" = "-1"; # Background for selected item
			"hl+" = base0D; # Highlight for selected item

			gutter = "-1"; # Remove the white margin at the left

			info = base0B; # Info text (usually count of items)
			border = base03; # Border color
			prompt = base0A; # Prompt text color
			pointer = base0F; # Pointer color (e.g., > for selected)
			marker = base0C; # Marker color (e.g., for multi-select)
			spinner = base0C; # Spinner color (during search)
		};
	};
}
