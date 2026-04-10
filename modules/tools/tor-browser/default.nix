{
  pkgs,
  lib,
  config,
  ...
}:

# Tor Browser - Anonymous web browser using Tor network
{
  options.tools.tor-browser = {
    enable = lib.mkEnableOption "Enables tor-browser.";
  };

  config = lib.mkIf config.tools.tor-browser.enable {
    home.packages = with pkgs; [
      tor-browser
    ];
  };
}
