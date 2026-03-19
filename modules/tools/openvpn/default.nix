{
  config,
  lib,
  pkgs,
  ...
}:

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
