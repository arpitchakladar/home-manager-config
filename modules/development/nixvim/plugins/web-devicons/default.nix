# File icons for various file types
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim.plugins.web-devicons = lib.mkIf cfg.enable {
    enable = true;
  };
}
