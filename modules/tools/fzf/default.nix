{ config, lib,... }:

{
	options.tools.fzf = {
		enable = lib.mkEnableOption "Enables fzf.";
	};

	config = lib.mkIf config.tools.fzf.enable {
		programs.fzf.enable = true;
		programs.fzf.defaultOptions = [
			"--height 40%"
			"--layout=reverse"
			(if config.fonts.nerdfont.fira-code.enable then "--pointer=\"\"" else "--pointer=\">\"")
			"--header=\" \""
			"--border=none"
		];

		programs.fzf.colors = with config.scheme.withHashtag; {
			fg = base05; # Foreground
			bg = base00; # Background
			hl = base0D; # Highlight

			"fg+" = base07; # Foreground for selected item
			"bg+" = base01; # Background for selected item
			"hl+" = base0D; # Highlight for selected item

			info = base0B; # Info text (usually count of items)
			border = base03; # Border color
			prompt = base0A; # Prompt text color
			pointer = base07; # Pointer color (e.g., > for selected)
			marker = base0C; # Marker color (e.g., for multi-select)
			spinner = base0C; # Spinner color (during search)
		};
	};
}