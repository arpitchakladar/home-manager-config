# Snippet engine for Neovim
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim.plugins.luasnip = lib.mkIf cfg.enable {
    enable = true;
  };
}
