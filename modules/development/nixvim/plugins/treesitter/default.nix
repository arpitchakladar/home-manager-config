# Syntax highlighting and parsing
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim.plugins.treesitter = lib.mkIf cfg.enable {
    enable = true;
    folding = {
      enable = true;
    };
    settings = {
      highlight = {
        enable = true;
      };
      indent = {
        enable = true;
      };
    };
  };
}
