{ pkgs, config, lib, ... }:

let
	nixvim = import (builtins.fetchGit {
		url = "https://github.com/nix-community/nixvim";
	});
in {
	imports = [
		nixvim.homeModules.nixvim
	];

	options.tools.nixvim = {
		enable = lib.mkEnableOption "Enables nixvim.";
	};

	config = lib.mkIf config.tools.nixvim.enable
	{
		programs.nixvim = {
			enable = true;
			keymaps = [
				{ key = "<c-h>"; action = "<c-w>h"; }
				{ key = "<c-w>"; action = "<c-w>j"; }
				{ key = "<c-k>"; action = "<c-w>k"; }
				{ key = "<c-l>"; action = "<c-w>l"; }
				{
					key = "<c-n>";
					action = "<cmd>NvimTreeToggle<cr>";
					mode = [ "n" "i" ];
				}
			];
			colorschemes.base16 = {
				enable = true;
				colorscheme = with config.scheme.withHashtag; {
					base00 = base00;
					base01 = base01;
					base02 = base02;
					base03 = base03;
					base04 = base04;
					base05 = base05;
					base06 = base06;
					base07 = base07;
					base08 = base08;
					base09 = base09;
					base0A = base0A;
					base0B = base0B;
					base0C = base0C;
					base0D = base0D;
					base0E = base0E;
					base0F = base0F;
				};
			};
			opts = {
				number = true;
				relativenumber = true;
				shiftwidth = 3;
				tabstop = 3;
				softtabstop = 3;
				expandtab = false;
				list = true;
				laststatus = 3;
			};
			clipboard.providers.xclip.enable = true;
			extraConfigLuaPre = with config.scheme.withHashtag; ''
				vim.opt.fillchars:append({ eob = " " })
				vim.opt.listchars = { tab = "| ", trail = "_", lead = "_" }
				vim.api.nvim_set_hl(0, "WinSeparator", {
					fg = "${base01}",
					bg = "${base00}",
				})
			'';
			plugins = {
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
						window = { border = "single"; };
					};
				};
			};
		};
	};
}
