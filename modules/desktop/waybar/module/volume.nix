{ config }:
with config.scheme.withHashtag;
{
  format = "{icon} {volume}%";
  format-muted = "󰻨";
  format-icons = [
    ""
    ""
    ""
  ];
  on-click = "pamixer -t";
  on-scroll-up = "pamixer -i 5";
  on-scroll-down = "pamixer -d 5";
}
