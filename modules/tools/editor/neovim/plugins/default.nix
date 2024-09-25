{ config }:

''
${builtins.readFile ./comment.lua}
${builtins.readFile ./lualine.lua}
${import ./treesitter.nix { inherit config; }}
${builtins.readFile ./base16.lua}
${builtins.readFile ./nvim-tree.lua}
''
