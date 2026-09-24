# Visual indentation guides
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim.plugins.indent-blankline = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      indent = {
        char = "┊";
        tab_char = "│";
      };
    };
  };
}
