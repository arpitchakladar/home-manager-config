{ config, mkIcon, ... }:
with config.scheme.withHashtag;
let
  iconColor = base09;
in
{
  format = "${mkIcon iconColor "{icon}"}  {capacity}%";
  format-charging = "${mkIcon iconColor "󰂄"}  {capacity}%";
  format-plugged = "${mkIcon iconColor "󰂅"}  {capacity}%";
  format-alt = "{time}  {icon}";
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
