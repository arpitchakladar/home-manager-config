# Treesitter - Syntax highlighting and parsing (nvim-treesitter)
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.treesitter = lib.mkIf config.development.nixvim.enable {
    enable = true;
    folding = {
      enable = true;
    };
    settings = {
      highlight = {
        enable = true;
      };
      indent = {
        enable = true;
      };
    };
  };
}
