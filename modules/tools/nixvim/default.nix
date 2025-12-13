{ pkgs, config, lib, ... }:

let
	nixvim = import (builtins.fetchGit {
		url = "https://github.com/nix-community/nixvim";
	});
in {
	imports = [
		nixvim.homeModules.nixvim
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
			'';
			performance = {
				byteCompileLua.enable = true;
				combinePlugins.enable = true;
			};
		};
	};
}
