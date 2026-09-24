# Completion plugin for auto-completion
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim.plugins.cmp = lib.mkIf cfg.enable {
    enable = true;
    autoEnableSources = true;
    settings = {
      snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
      mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<Tab>" = "cmp.mapping.select_next_item()";
        "<S-Tab>" = "cmp.mapping.select_prev_item()";
        "<Down>" = "cmp.mapping.select_next_item()";
        "<Up>" = "cmp.mapping.select_prev_item()";
        "<C-u>" = "cmp.mapping.scroll_docs(-4)"; # scroll docs up
        "<C-d>" = "cmp.mapping.scroll_docs(4)"; # scroll docs down

        "<Escape>" = builtins.readFile ./escape.lua;
      };
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };
  };
}
