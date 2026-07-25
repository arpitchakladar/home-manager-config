{ config, iconColor }:
with config.scheme.withHashtag;
{
  format-wifi = "<span foreground='${iconColor}'>{icon}</span> {signalStrength}%";
  format-ethernet = "<span foreground='${iconColor}'></span> {ipaddr}";
  format-disconnected = "";
  tooltip-format = "{ifname}";
  tooltip-format-wifi = "{essid} ({signalStrength}%)";
  tooltip-format-ethernet = "Wired: {ipaddr}";
  tooltip-format-disconnected = "Disconnected";
  format-icons = [
    "󰢼"
    "󰢽"
    "󰢾"
  ];
}
