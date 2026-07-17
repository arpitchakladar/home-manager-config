# LSD - Ls alternative with icons and colors (Rust-based)
{ config, lib, ... }:
{
  options.file-management.lsd = {
    enable = lib.mkEnableOption "Enables lsd.";
  };

  config = lib.mkIf config.file-management.lsd.enable {
    programs.lsd = {
      enable = true;
      settings.icons.separator = "  ";
    };
  };
}
