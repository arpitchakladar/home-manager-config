{ config, lib, ... }:

# Colorscheme - Base16 theme configuration for nixvim
{
  config.programs.nixvim.colorschemes.base16 = lib.mkIf config.programs.nixvim.enable {
    enable = true;
    colorscheme = with config.scheme.withHashtag; {
      base00 = base00;
      base01 = base01;
      base02 = base02;
      base03 = base03;
      base04 = base04;
      base05 = base05;
      base06 = base06;
      base07 = base07;
      base08 = base08;
      base09 = base09;
      base0A = base0A;
      base0B = base0B;
      base0C = base0C;
      base0D = base0D;
      base0E = base0E;
      base0F = base0F;
    };
  };
}
