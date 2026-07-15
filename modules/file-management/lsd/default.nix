{ config, lib, ... }:

# LSD - Ls alternative with icons and colors (Rust-based)
{
  config = lib.mkIf config.programs.lsd.enable {
    programs.lsd = {
      settings.icons.separator = "  ";
    };
  };
}
