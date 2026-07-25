{
  config,
  lib,
  pkgs,
}:
with config.scheme.withHashtag;
{
  exec = "${pkgs.runtimeShell} -c '${lib.getExe' pkgs.iproute2 "ip"} a | ${lib.getExe pkgs.gnugrep} -q tun0 && printf \" VPN\"'";
  interval = 5;
  format = "{}";
}
