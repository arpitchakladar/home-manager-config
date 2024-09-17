config:

''
${import ./theme.nix config}
${builtins.readFile ./init.lua}
''
