{ config, lib, ... }:

# Telescope - Fuzzy finder
{
  config.programs.nixvim.plugins.telescope = lib.mkIf config.programs.nixvim.enable {
    enable = true;
    extensions = {
      fzf-native.enable = true; # faster fuzzy sorting
      ui-select.enable = true; # use telescope for vim.ui.select (code actions etc.)
    };
    settings = {
      defaults = {
        layout_strategy = "horizontal";
        layout_config = {
          horizontal = {
            preview_width = 0.55;
            results_width = 0.45;
          };
          width = 0.87;
          height = 0.80;
        };
        mappings = {
          i = {
            "<C-k>".__raw = "require('telescope.actions').move_selection_previous";
            "<C-j>".__raw = "require('telescope.actions').move_selection_next";
            "<Escape>".__raw = "require('telescope.actions').close";
          };
        };
      };
    };
    keymaps = {
      # Files
      "<leader>ff" = {
        action = "find_files";
        options.desc = "Find files";
      };
      "<leader>fg" = {
        action = "live_grep";
        options.desc = "Live grep";
      };
      "<leader>fb" = {
        action = "buffers";
        options.desc = "Find buffers";
      };
      "<leader>fr" = {
        action = "oldfiles";
        options.desc = "Recent files";
      };

      # LSP
      "<leader>fd" = {
        action = "diagnostics";
        options.desc = "Diagnostics";
      };
      "<leader>fs" = {
        action = "lsp_document_symbols";
        options.desc = "Document symbols";
      };

      # Git
      "<leader>gc" = {
        action = "git_commits";
        options.desc = "Git commits";
      };
      "<leader>gb" = {
        action = "git_branches";
        options.desc = "Git branches";
      };

      # Misc
      "<leader>fh" = {
        action = "help_tags";
        options.desc = "Help tags";
      };
      "<leader>fc" = {
        action = "commands";
        options.desc = "Commands";
      };
      "<leader>fk" = {
        action = "keymaps";
        options.desc = "Find keymaps";
      };
    };
  };
}
