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
			performance.byteCompileLua.enable = true;
		};
	};
}
