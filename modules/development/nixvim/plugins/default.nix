# Collection of nixvim plugin configurations
{ ... }:
{
  imports = [
    ./cmp.nix
    ./comment.nix
    ./dap-ui.nix
    ./dap-virtual-text.nix
    ./dap.nix
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
