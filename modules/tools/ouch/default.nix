{
  pkgs,
  lib,
  config,
  ...
}:

# Ouch! - CLI tool for compressing and decompressing various formats.
{
  options.tools.ouch = {
    enable = lib.mkEnableOption "Enables ouch.";
  };

  config = lib.mkIf config.tools.ouch.enable {
    home.packages = with pkgs; [
      ouch
    ];
  };
}
