# VPN - Just indicates if VPN is connected with openvpn
{
  pkgs,
  lib,
  config,
}:
with config.scheme.withHashtag;
{
  type = "custom/script";
  exec-if = "${pkgs.runtimeShell} -c '${lib.getExe' pkgs.iproute2 "ip"} a | ${lib.getExe pkgs.gnugrep} -q tun0'";
  exec = "echo VPN";
  interval = 5;

  format = "%{T2}%{F${base03}} %{F-}%{T-} <label>";
  label = "%output%";
}
