{ config }:

# Ethernet-separator - Visual separator for ethernet module
with config.scheme.withHashtag;
{
  type = "internal/network";
  interface = "enp4s0";
  interface-type = "wired";

  format-connected = " %{F${base03}}%{T3}│%{T-}%{F-} ";
  format-disconnected = "";

  label-connected = "";
  label-disconnected = "";
}
