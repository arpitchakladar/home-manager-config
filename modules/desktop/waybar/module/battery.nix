{ config, iconColor }:
with config.scheme.withHashtag;
{
  format = "<span foreground='${iconColor}'>{icon}</span> {capacity}%";
  format-charging = "<span foreground='${iconColor}'>󰂄</span> {capacity}%";
  format-plugged = "<span foreground='${iconColor}'>󰁹</span> {capacity}%";
  format-alt = "{time} {icon}";
  format-icons = [
    "󰁺"
    "󰁻"
    "󰁼"
    "󰁽"
    "󰁾"
    "󰁿"
    "󰂀"
    "󰂁"
    "󰂂"
    "󰁹"
  ];
}
