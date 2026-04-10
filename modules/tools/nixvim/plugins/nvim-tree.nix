{ config, lib, ... }:

# Nvim-tree - File explorer sidebar (nvim-tree.lua)
{
  config.programs.nixvim.plugins.nvim-tree = lib.mkIf config.tools.nixvim.enable {
    enable = true;
    settings = {
      filters = {
        dotfiles = false;
        git_clean = false;
        no_buffer = false;
        custom = { };
      };
      git = {
        enable = true;
        ignore = false;
      };
      view = {
        width = 30;
      };
      renderer = {
        indent_markers = {
          enable = true;
          inline_arrows = false;
          icons = {
            corner = "└";
            edge = "│";
            item = "├";
            bottom = "─";
            none = " ";
          };
        };
        icons = {
          show = {
            folder = true;
            folder_arrow = false;
            file = true;
            git = true;
          };
        };
      };
    };
  };
}
