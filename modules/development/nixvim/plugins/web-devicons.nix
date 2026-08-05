# File icons for various file types
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.web-devicons = lib.mkIf config.development.nixvim.enable {
    enable = true;
  };
}
