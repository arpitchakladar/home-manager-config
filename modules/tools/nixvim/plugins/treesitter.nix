{ config, lib, ... }:

# Treesitter - Syntax highlighting and parsing (nvim-treesitter)
{
  config.programs.nixvim.plugins.treesitter = lib.mkIf config.tools.nixvim.enable {
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
