{ config, mkIcon }:
with config.scheme.withHashtag;
let
  iconColor = base0B;
in
{
  interval = 2;

  format-wifi = "${mkIcon iconColor "{icon}"}  󰁅{bandwidthDownBytes}  󰁝{bandwidthUpBytes}";
  format-ethernet = "${mkIcon iconColor ""}  󰁅{bandwidthDownBytes}  󰁝{bandwidthUpBytes}";
  format-disconnected = "${mkIcon iconColor "󰤮"}  Disconnected";

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
