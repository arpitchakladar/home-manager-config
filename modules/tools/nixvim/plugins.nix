{ pkgs, config, lib, ... }:

{
	config = lib.mkIf config.tools.nixvim.enable {
		programs.nixvim.plugins = {
			comment = {
				enable = true;
			};
			lualine = {
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
			noice = {
				enable = true;
				cmdline = {
					enabled = true;
					view = "cmdline_popup";
				};
				popupmenu = {
					enabled = true;
					backend = "cmp";
				};
				presets = {
					command_palette = true;
				};
			};
			nvim-tree = {
				enable = true;
				settings = {
					filters = {
						dotfiles = false;
						git_clean = false;
						no_buffer = false;
						custom = {};
					};
					git = {
						enable = true;
						ignore = false;
					};
					view = {
						width = {
							padding = 0;
						};
					};
					renderer = {
						indent_markers = {
							enable = true;
							inline_arrows = false;
							icons = {
								corner = "└";
								edge = "│";
								item = "├";
								bottom = "─";
								none = " ";
							};
						};
						icons = {
							show = {
								folder = true;
								folder_arrow = false;
								file = true;
								git = true;
							};
						};
					};
				};
			};
			treesitter = {
				enable = true;
				settings = {
					highlight = { enable = true; };
					indent = { enable = true; };
				};
			};
			web-devicons = {
				enable = true;
			};
			which-key = {
				enable = true;
				settings = {
					plugins = {
						marks = true;
						registers = true;
						spelling = { enabled = true; suggestions = 20; };
					};
					win = { border = "single"; };
				};
			};
		};
	};
}
