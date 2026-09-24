# Git integration: signs, blame, diffs and hunk operations
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development.nixvim;
  base16Colors = import ../../../../colors/base16 { inherit config lib pkgs; };
in
{
  config.programs.nixvim = lib.mkIf cfg.enable {
    plugins.gitsigns = {
      enable = true;

      settings = {
        signs = {
          add.text = "┃";
          change.text = "┃";
          delete.text = "▁";
          topdelete.text = "▔";
          changedelete.text = "~";
          untracked.text = "┆";
        };

        signcolumn = false;
        numhl = true;
        current_line_blame = false;
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>";

        on_attach = builtins.readFile ./on-attach.lua;
      };
    };

    highlight = with base16Colors.colorsWithHashPrefix; {
      GitSignsAdd.fg = base0B;
      GitSignsChange.fg = base0A;
      GitSignsDelete.fg = base08;
      GitSignsTopdelete.fg = base08;
      GitSignsChangedelete.fg = base0A;
      GitSignsUntracked.fg = base0C;
      GitSignsCurrentLineBlame.fg = base04;
    };
  };
}
