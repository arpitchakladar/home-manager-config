# Indent-blankline - Visual indentation guides (indent-blankline.nvim)
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.indent-blankline = lib.mkIf config.development.nixvim.enable {
    enable = true;
    settings = {
      indent = {
        char = "┊";
        tab_char = "│";
      };
    };
  };
}
