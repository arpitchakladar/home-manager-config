{ config }:
with config.scheme.withHashtag;
{
  format-wifi = "{icon} {signalStrength}%";
  format-ethernet = " {ipaddr}";
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
