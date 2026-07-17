# Bottom - Cross-platform graphical process/system monitor (Rust-based)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.system.bottom = {
    enable = lib.mkEnableOption "Enables bottom.";
    package = lib.mkPackageOption pkgs "bottom" { };
  };

  config = lib.mkIf config.system.bottom.enable {
    programs.bottom = {
      enable = true;
      package = config.system.bottom.package;
    };
  };
}
