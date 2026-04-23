{
  pkgs,
  lib,
  config,
  ...
}:

# Tor - Local proxy server for connecting to the tor network
{
  options.programs.tor = {
    enable = lib.mkEnableOption "Enables tor.";
    package = lib.mkPackageOption pkgs "tor" { };
  };

  config = lib.mkIf config.programs.tor.enable {
    home.packages = [ config.programs.tor.package ];

    home.file.".config/tor/torrc".text = ''
      SocksPort 127.0.0.1:9050
      CookieAuthentication 1
      # Prevents Tor from writing to disk too much
      AvoidDiskWrites 1
    '';
  };
}
