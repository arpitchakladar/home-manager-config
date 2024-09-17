{ pkgs, config, ... }:

{
	programs.neovim =
	let
		toLua = str: "lua << EOF\n${str}\nEOF\n";
		toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
	in {
		enable = true;
		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;

		extraLuaConfig = ''
${import ./colorscheme.nix config}
${builtins.readFile ./options.lua}
${builtins.readFile ./keybindings.lua}
'';
		plugins = with pkgs.vimPlugins; [
			{
				plugin = comment-nvim;
				config = toLuaFile ./plugins/comment.lua;
			}

			{
				plugin = lualine-nvim;
				config = toLua (import ./plugins/lualine/default.nix config);
			}

			nvim-web-devicons
			{
				plugin = nvim-tree-lua;
				config = toLuaFile ./plugins/nvim-tree.lua;
			}
		];
	};
}
