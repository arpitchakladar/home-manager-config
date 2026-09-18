# Collection of nixvim plugin configurations
{ ... }:
{
  imports = [
    ./cmp
    ./comment
    ./dap-ui
    ./dap-virtual-text
    ./dap
    ./gitsigns
    ./indent-blankline
    ./lsp
    ./lualine
    ./luasnip
    ./noice
    ./nvim-tree
    ./telescope
    ./treesitter
    ./web-devicons
    ./which-key
  ];
}
