{
  pkgs,
  lib,
  config,
  ...
}:

# Ouch! - CLI tool for compressing and decompressing various formats.
{
  options.programs.ouch = {
    enable = lib.mkEnableOption "Enables ouch.";
  };

  config = lib.mkIf config.programs.ouch.enable {
    home.packages = with pkgs; [
      ouch
    ];
  };
}
