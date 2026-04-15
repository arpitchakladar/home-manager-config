{ config, lib, ... }:

# Comment - Comment toggling plugin (comment.nvim)
{
  config.programs.nixvim.plugins.comment = lib.mkIf config.tools.nixvim.enable {
    enable = true;
    settings = {
      toggler = {
        line = "gcc"; # toggle line comment
        block = "gbc"; # toggle block comment
      };
      opleader = {
        line = "gc"; # line comment operator (gc + motion)
        block = "gb"; # block comment operator (gb + motion)
      };
      extra = {
        above = "gcO"; # add comment line above
        below = "gco"; # add comment line below
        eol = "gcA"; # add comment at end of line
      };
    };
  };
}
