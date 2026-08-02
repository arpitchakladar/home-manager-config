# LSD - Ls alternative with icons and colors (Rust-based)
{ config, lib, ... }:
{
  options.file-management.lsd = {
    enable = lib.mkEnableOption "Enables lsd.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.lsd.package;
      description = "The lsd package to use.";
    };
  };

  config = lib.mkIf config.file-management.lsd.enable {
    programs.lsd = {
      enable = true;
      settings.icons.separator = "  ";
    };
  };
}
