{ config, pkgs, lib }:

{
	configuration = import ./config { inherit config; };

	list = with pkgs.vimPlugins; lib.mkMerge [
		[
			comment-nvim
			lualine-nvim
			nvim-treesitter
			nvim-web-devicons
			nvim-tree-lua
			which-key-nvim
			bufferline-nvim
			(base16-vim.overrideAttrs (old: {
				patchPhase = "ln -s ${config.scheme base16-vim} colors/base16-scheme.vim";
			}))
		]
		(if config.tools.editor.neovim.profile == "full" then
			[
				noice-nvim
				dressing-nvim
				nvim-lspconfig
			]
		else [])
	];

	requirements = with pkgs; [
		gcc # for treesitter
	];
}
