# Popup for keybindings
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim.plugins.which-key = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      plugins = {
        marks = true;
        registers = true;
        spelling = {
          enabled = true;
        };
      };
      win = {
        border = "single";
      };

      # Group descriptions for leader prefixes
      spec = [
        {
          __unkeyed-1 = "<leader>g";
          group = "+Git";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "+Find";
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "+Debug";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "+LSP";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "+Comment";
        }
        {
          __unkeyed-1 = "<leader>n";
          group = "+Explorer";
        }
      ];
    };
  };
}
