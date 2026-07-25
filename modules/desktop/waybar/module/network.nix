{ config, iconColor }:
with config.scheme.withHashtag;
{
  interval = 2;

  format-wifi = "<span foreground='${iconColor}'>{icon}</span>  󰁅 {bandwidthDownBytes}  󰁝 {bandwidthUpBytes}";
  format-ethernet = "<span foreground='${iconColor}'></span>  󰁅 {bandwidthDownBytes}  󰁝 {bandwidthUpBytes}";
  format-disconnected = "<span foreground='${iconColor}'>󰤮</span>  Disconnected";

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
