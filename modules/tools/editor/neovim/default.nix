{ pkgs, config, lib, ... }:

{
	options.tools.editor.neovim = {
		enable = lib.mkEnableOption "Enables neovim.";
	};

	config = lib.mkIf config.tools.editor.neovim.enable {
		programs.neovim.enable = true;
		programs.neovim.viAlias = true;
		programs.neovim.vimAlias = true;
		programs.neovim.vimdiffAlias = true;
		programs.neovim.defaultEditor = true;

		programs.neovim.extraPackages = with pkgs; [
			gcc # Required for treesitter
		];

		programs.neovim.extraLuaConfig =
	''
${import ./config}
${import ./plugins { inherit config; }}
	'';

		programs.neovim.plugins = with pkgs.vimPlugins; [
			comment-nvim
			lualine-nvim
			nvim-treesitter
			nvim-web-devicons
			nvim-tree-lua
			(base16-vim.overrideAttrs (old: {
				patchPhase = "ln -s ${config.scheme base16-vim} colors/base16-scheme.vim";
			}))
		];
	};
}
