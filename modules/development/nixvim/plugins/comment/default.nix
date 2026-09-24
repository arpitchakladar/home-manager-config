# Comment toggling plugin
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim.plugins.comment = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      toggler = {
        line = "<leader>cc"; # toggle line comment
        block = "<leader>cb"; # toggle block comment
      };
      opleader = {
        line = "<leader>cc"; # toggle line comment
        block = "<leader>cb"; # toggle block comment
      };
      extra = {
        above = "<leader>cu"; # add comment line above
        below = "<leader>cd"; # add comment line below
        eol = "<leader>ce"; # add comment at end of line
      };
    };
  };
}
