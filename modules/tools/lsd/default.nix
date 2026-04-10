{ config, lib, ... }:

# LSD - Ls alternative with icons and colors (Rust-based)
{
  options.tools.lsd = {
    enable = lib.mkEnableOption "Enables lsd.";
  };

  config = lib.mkIf config.tools.lsd.enable {
    programs.lsd = {
      enable = true;
      settings.icons.separator = "  ";
    };
  };
}
