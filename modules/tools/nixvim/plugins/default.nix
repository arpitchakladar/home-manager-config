{ ... }:

# Plugins - Collection of nixvim plugin configurations
{
  imports = [
    ./cmp.nix
    ./comment.nix
    ./gitsigns.nix
    ./indent-blankline.nix
    ./lsp.nix
    ./lualine.nix
    ./luasnip.nix
    ./noice.nix
    ./nvim-tree.nix
    ./telescope.nix
    ./treesitter.nix
    ./web-devicons.nix
    ./which-key.nix
  ];
}
