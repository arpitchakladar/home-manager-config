{ config }:

''
${builtins.readFile ./comment.lua}
${builtins.readFile ./lualine.lua}
${import ./treesitter.nix { inherit config; }}
${builtins.readFile (config.scheme {
	template = builtins.readFile ./base16.mustache.lua;
})}
${builtins.readFile ./nvim-tree.lua}
''