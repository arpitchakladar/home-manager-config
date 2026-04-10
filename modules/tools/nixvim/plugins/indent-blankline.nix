{ config, lib, ... }:

# Indent-blankline - Visual indentation guides (indent-blankline.nvim)
{
  config.programs.nixvim.plugins.indent-blankline = lib.mkIf config.tools.nixvim.enable {
    enable = true;
    settings = {
      indent = {
        char = "┊";
        tab_char = "│";
      };
    };
  };
}
