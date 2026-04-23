{ config, lib, ... }:

# Web-devicons - File icons for various file types (nvim-web-devicons)
{
  config.programs.nixvim.plugins.web-devicons = lib.mkIf config.programs.nixvim.enable {
    enable = true;
  };
}
