{
  config,
  lib,
  pkgs,
  iconColor,
}:
with config.scheme.withHashtag;
let
  vpnCheckScript = pkgs.writeShellScript "vpn-check" ''
    if ${lib.getExe' pkgs.iproute2 "ip"} a | ${lib.getExe pkgs.gnugrep} -q tun0; then
      printf '<span foreground="${iconColor}"></span> VPN'
    fi
  '';
in
{
  exec = "${vpnCheckScript}";
  interval = 5;
  format = "{}";
}
