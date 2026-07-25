{
  config,
  lib,
  pkgs,
  mkIcon,
}:
with config.scheme.withHashtag;
let
  iconColor = base0C;
  vpnCheckScript = pkgs.writeShellScript "vpn-check" ''
    if ${lib.getExe' pkgs.iproute2 "ip"} a | ${lib.getExe pkgs.gnugrep} -q tun0; then
      printf '${mkIcon iconColor ""}  VPN'
    fi
  '';
in
{
  exec = "${vpnCheckScript}";
  interval = 5;
  format = "{}";
}
