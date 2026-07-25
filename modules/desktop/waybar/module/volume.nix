{ config, iconColor }:
with config.scheme.withHashtag;
{
  format = "<span foreground='${iconColor}'>{icon}</span> {volume}%";
  format-muted = "<span foreground='${iconColor}'>󰝟</span>";
  format-icons = [
    ""
    ""
    ""
  ];
  on-click = "pamixer -t";
  on-scroll-up = "pamixer -i 5";
  on-scroll-down = "pamixer -d 5";
}
