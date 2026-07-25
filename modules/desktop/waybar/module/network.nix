{ config, mkIcon }:
with config.scheme.withHashtag;
let
  iconColor = base0B;
  downloadIcon = mkIcon base0F "󰁅";
  uploadIcon = mkIcon base0F "󰁝";
in
{
  interval = 2;

  format-wifi = "${mkIcon iconColor "{icon}"}  ${downloadIcon}{bandwidthDownBytes}  ${uploadIcon}{bandwidthUpBytes}";
  format-ethernet = "${mkIcon iconColor ""}  ${downloadIcon}{bandwidthDownBytes}  ${uploadIcon}{bandwidthUpBytes}";
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
