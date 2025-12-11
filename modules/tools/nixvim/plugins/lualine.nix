{ config, lib, ... }:

{
	config.programs.nixvim.plugins.lualine = lib.mkIf config.tools.nixvim.enable {
		enable = true;
		settings = {
			options = {
				theme = with config.scheme.withHashtag; {
					normal = {
						a = { fg = base00; bg = base0D; gui = "bold"; };
						b = { fg = base05; bg = base01; };
						c = { fg = base05; bg = base00; };
					};
					insert = {
						a = { fg = base00; bg = base0B; gui = "bold"; };
						b = { fg = base05; bg = base01; };
						c = { fg = base05; bg = base00; };
					};
					visual = {
						a = { fg = base00; bg = base0A; gui = "bold"; };
						b = { fg = base05; bg = base01; };
						c = { fg = base05; bg = base00; };
					};
					replace = {
						a = { fg = base00; bg = base08; gui = "bold"; };
						b = { fg = base05; bg = base01; };
						c = { fg = base05; bg = base00; };
					};
					inactive = {
						a = { fg = base04; bg = base00; gui = "bold"; };
						b = { fg = base04; bg = base00; };
						c = { fg = base04; bg = base00; };
					};
				};
				icons_enabled = true;
			};
		};
	};
}
