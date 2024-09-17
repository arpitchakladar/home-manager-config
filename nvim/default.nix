{ pkgs, config, ... }:

{
	programs.neovim.enable = true;
	programs.neovim.viAlias = true;
	programs.neovim.vimAlias = true;
	programs.neovim.vimdiffAlias = true;

	programs.neovim.extraLuaConfig =
''
${builtins.readFile ./options.lua}
${builtins.readFile ./keybindings.lua}
'';

	programs.neovim.plugins =
	with pkgs.vimPlugins;
	let
		toLua = str: "lua << EOF\n${str}\nEOF\n";
		toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
	in [
		{
			plugin = comment-nvim;
			config = toLuaFile ./plugins/comment.lua;
		}

		{
			plugin = lualine-nvim;
			config = toLuaFile ./plugins/lualine.lua;
		}

		{
			plugin = base16-nvim;
			config = toLua (import ./plugins/base16.nix config);
		}

		nvim-web-devicons

		{
			plugin = nvim-tree-lua;
			config = toLuaFile ./plugins/nvim-tree.lua;
		}
	];
}
