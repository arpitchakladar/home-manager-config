# Modern UI for Neovim
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim.plugins.noice = lib.mkIf cfg.enable {
    enable = true;
  };
}
