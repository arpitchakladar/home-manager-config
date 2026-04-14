{
  pkgs,
  lib,
  config,
}:

# VPN - Just indicates if VPN is connected with openvpn
with config.scheme.withHashtag;
{
  type = "custom/script";
  exec-if = "${lib.getExe pkgs.zsh} -c '${lib.getExe' pkgs.iproute2 "ip"} a | ${lib.getExe pkgs.gnugrep} -q tun0'";
  exec = "echo VPN";
  interval = 5;

  format = "%{T2}%{F${base03}} %{F-}%{T-} <label>";
  label = "%output%";
}
