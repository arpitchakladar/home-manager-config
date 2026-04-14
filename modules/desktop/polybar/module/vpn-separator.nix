{
  pkgs,
  lib,
  config,
}:

# VPN - Visual separator for VPN module
with config.scheme.withHashtag;
{
  type = "custom/script";
  exec-if = "${lib.getExe pkgs.zsh} -c '${lib.getExe' pkgs.iproute2 "ip"} a | ${lib.getExe pkgs.gnugrep} -q tun0'";
  exec = "echo VPN";
  interval = 5;

  format = " %{F${base03}}%{T3}│%{T-}%{F-} ";
  label = "%output%";
}
