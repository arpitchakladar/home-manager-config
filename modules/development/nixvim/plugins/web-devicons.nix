# Web-devicons - File icons for various file types (nvim-web-devicons)
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.web-devicons = lib.mkIf config.development.nixvim.enable {
    enable = true;
  };
}
