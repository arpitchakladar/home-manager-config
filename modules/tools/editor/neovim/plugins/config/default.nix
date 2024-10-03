{ config }:

let
	extra = if config.tools.editor.neovim.configuration == "full" then
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
${builtins.readFile ./lualine.lua}
${import ./treesitter.nix { inherit config; }}
${builtins.readFile (config.scheme {
	template = builtins.readFile ./base16.mustache.lua;
})}
${builtins.readFile ./nvim-tree.lua}
${extra}
''
