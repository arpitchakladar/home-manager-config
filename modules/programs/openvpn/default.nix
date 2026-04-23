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
  };

  config = lib.mkIf config.programs.openvpn.enable {
    home.packages = with pkgs; [
      openvpn
    ];
  };
}
