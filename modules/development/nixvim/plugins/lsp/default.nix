# Language Server Protocol configuration
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim = lib.mkIf cfg.enable {
    plugins.lsp = {
      enable = true;
      inlayHints = true;
      autoLoad = true;

      keymaps = {
        lspBuf = {
          "<leader>lh" = "hover";
          "<leader>lr" = "references";
          "<leader>ld" = "definition";
          "<leader>li" = "implementation";
          "<leader>lt" = "type_definition";
          "<leader>lD" = "declaration";
          "<leader>lR" = "rename";
          "<leader>la" = "code_action";
          "<leader>lf" = "format";
          "<leader>ls" = "signature_help";
          "<leader>lwa" = "add_workspace_folder";
          "<leader>lwr" = "remove_workspace_folder";
          "<leader>lwl" = "list_workspace_folders";
        };
        diagnostic = {
          "<leader>le" = "open_float";
          "<leader>lq" = "setloclist";
          "[d" = "goto_prev";
          "]d" = "goto_next";
        };
      };
    };

    autoCmd = [
      {
        event = [ "CursorHold" ];
        pattern = "*";
        callback.__raw = builtins.readFile ./open-diagnostic-float.lua;
      }
    ];
  };
}
