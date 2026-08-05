# Git status in the sign column
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.gitsigns = lib.mkIf config.development.nixvim.enable {
    enable = true;
  };
}
