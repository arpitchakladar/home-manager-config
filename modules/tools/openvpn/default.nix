{
  config,
  lib,
  pkgs,
  ...
}:

# OpenVPN - Open-source VPN client for secure remote access
{
  options.tools.openvpn = {
    enable = lib.mkEnableOption "Enables openvpn.";
  };

  config = lib.mkIf config.tools.openvpn.enable {
    home.packages = with pkgs; [
      openvpn
    ];
  };
}
