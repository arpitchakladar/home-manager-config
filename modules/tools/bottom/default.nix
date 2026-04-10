{ config, lib, ... }:

# Bottom - Cross-platform graphical process/system monitor (Rust-based)
{
  options.tools.bottom = {
    enable = lib.mkEnableOption "Enables bottom.";
  };

  config = lib.mkIf config.tools.bottom.enable {
    programs.bottom.enable = true;
  };
}
