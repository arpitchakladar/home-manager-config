{
  pkgs,
  lib,
  config,
  ...
}:

# Unar - Command-line archive extractor for various formats (zip, rar, etc.)
{
  options.tools.unar = {
    enable = lib.mkEnableOption "Enables unar.";
  };

  config = lib.mkIf config.tools.unar.enable {
    home.packages = with pkgs; [
      unar
    ];
  };
}
