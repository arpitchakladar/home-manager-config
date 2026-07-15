{
  config,
  lib,
  pkgs,
  ...
}:

# Bottom - Cross-platform graphical process/system monitor (Rust-based)
{
  config = lib.mkIf config.programs.bottom.enable {
    programs.bottom = {
      package = pkgs.bottom;
    };
  };
}
