{
  config,
  lib,
  pkgs,
  ...
}:

# OpenVPN - Open-source VPN client for secure remote access
{
  options.programs.openvpn = {
    enable = lib.mkEnableOption "Enables openvpn.";
    package = lib.mkPackageOption pkgs "openvpn" { };
  };

  config = lib.mkIf config.programs.openvpn.enable {
    home.packages = [ config.programs.openvpn.package ];
  };
}
