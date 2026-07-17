# OpenVPN - Open-source VPN client for secure remote access
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.security.openvpn = {
    enable = lib.mkEnableOption "Enables openvpn.";
    package = lib.mkPackageOption pkgs "openvpn" { };
  };

  config = lib.mkIf config.security.openvpn.enable {
    home.packages = [ config.security.openvpn.package ];
  };
}
