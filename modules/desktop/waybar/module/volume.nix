{ config, mkIcon }:
with config.scheme.withHashtag;
let
  iconColor = base0A;
in
{
  format = "${mkIcon iconColor "{icon}"}  {volume}%";
  format-muted = mkIcon iconColor " ";
  format-icons = [
    ""
    ""
    ""
  ];
  on-click = "pamixer -t";
  on-scroll-up = "pamixer -i 5";
  on-scroll-down = "pamixer -d 5";
}
