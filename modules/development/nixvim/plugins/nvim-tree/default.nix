# File explorer sidebar
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim = lib.mkIf cfg.enable {
    plugins.nvim-tree = {
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

    keymaps = [
      {
        key = "<leader>nt";
        action = "<cmd>NvimTreeToggle<cr>";
        mode = [
          "n"
        ];
        options.desc = "Toggle file explorer";
      }
    ];
  };
}
