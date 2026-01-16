{ config, lib, ... }:

{
	imports = [
		./colorscheme.nix
		./keymaps.nix
		./plugins
	];

	options.tools.nixvim = {
		enable = lib.mkEnableOption "Enables nixvim.";
	};

	config = lib.mkIf config.tools.nixvim.enable
	{
		programs.nixvim = {
			enable = true;
			defaultEditor = true;
			opts = {
				number = true;
				relativenumber = true;
				shiftwidth = 3;
				tabstop = 3;
				softtabstop = 3;
				expandtab = false;
				list = true;
				laststatus = 3;
				foldlevel = 99;
				clipboard = "unnamedplus";
			};
			clipboard.providers.xclip.enable = true;
			extraConfigLuaPre = with config.scheme.withHashtag; ''
				vim.opt.fillchars:append({ eob = " " })
				vim.opt.listchars = { tab = "| ", trail = "_", lead = "_" }
				vim.api.nvim_set_hl(0, "WinSeparator", {
					fg = "${base01}",
					bg = "${base00}",
				})
				vim.api.nvim_set_hl(0, 'NotifyERRORBorder', { fg = '${base08}' })
				vim.api.nvim_set_hl(0, 'NotifyWARNBorder', { fg = '${base09}' })
				vim.api.nvim_set_hl(0, 'NotifyINFOBorder', { fg = '${base0B}' })
				vim.api.nvim_set_hl(0, 'NotifyDEBUGBorder', { fg = '${base03}' })
				vim.api.nvim_set_hl(0, 'NotifyTRACEBorder', { fg = '${base0E}' })
				
				vim.api.nvim_set_hl(0, 'NotifyERRORIcon', { fg = '${base08}' })
				vim.api.nvim_set_hl(0, 'NotifyWARNIcon', { fg = '${base09}' })
				vim.api.nvim_set_hl(0, 'NotifyINFOIcon', { fg = '${base0B}' })
				vim.api.nvim_set_hl(0, 'NotifyDEBUGIcon', { fg = '${base03}' })
				vim.api.nvim_set_hl(0, 'NotifyTRACEIcon', { fg = '${base0E}' })
				
				vim.api.nvim_set_hl(0, 'NotifyERRORTitle', { fg = '${base08}' })
				vim.api.nvim_set_hl(0, 'NotifyWARNTitle', { fg = '${base09}' })
				vim.api.nvim_set_hl(0, 'NotifyINFOTitle', { fg = '${base0B}' })
				vim.api.nvim_set_hl(0, 'NotifyDEBUGTitle', { fg = '${base03}' })
				vim.api.nvim_set_hl(0, 'NotifyTRACETitle', { fg = '${base0E}' })
				
				vim.api.nvim_set_hl(0, 'NotifyERRORBody', { link = 'Normal' })
				vim.api.nvim_set_hl(0, 'NotifyWARNBody', { link = 'Normal' })
				vim.api.nvim_set_hl(0, 'NotifyINFOBody', { link = 'Normal' })
				vim.api.nvim_set_hl(0, 'NotifyDEBUGBody', { link = 'Normal' })
				vim.api.nvim_set_hl(0, 'NotifyTRACEBody', { link = 'Normal' })

				vim.api.nvim_create_autocmd({ "FileType" }, {
					pattern = "*",
					callback = function()
						vim.opt_local.expandtab = false
						vim.opt_local.shiftwidth = 3
						vim.opt_local.softtabstop = 3
						vim.opt_local.tabstop = 3
					end,
				})

				vim.api.nvim_create_autocmd({ "FileType" }, {
					pattern = { "yaml", "yml" },
					callback = function()
						vim.opt_local.expandtab = true
						vim.opt_local.shiftwidth = 2
						vim.opt_local.softtabstop = 2
						vim.opt_local.tabstop = 2
					end,
				})
			'';
			performance = {
				byteCompileLua.enable = true;
				combinePlugins.enable = true;
			};
		};

		home.sessionVariables.EDITOR = "nvim";
	};
}
