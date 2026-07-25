{ config }:
with config.scheme.withHashtag;
{
  format = "{icon} {capacity}%";
  format-charging = "󰂄 {capacity}%";
  format-plugged = "󰁹 {capacity}%";
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
