{ config }:

let
	fullExtra = if config.tools.editor.neovim.profile == "full" then
''
${builtins.readFile ./lsp-config.lua}
${builtins.readFile ./dressing.lua}
${builtins.readFile (config.scheme {
	template = builtins.readFile ./noice.mustache.lua;
})}
''
	else "";
in
''
${builtins.readFile ./comment.lua}
${builtins.readFile (config.scheme {
	template = builtins.readFile ./lualine.mustache.lua;
})}
${import ./treesitter.nix { inherit config; }}
${builtins.readFile (config.scheme {
	template = builtins.readFile ./base16.mustache.lua;
})}
${builtins.readFile ./nvim-tree.lua}
${fullExtra}
''
