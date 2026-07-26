{ ... }:
let
  mkIcon = color: icon: "<span foreground='${color}' font_size='120%'>${icon}</span>";
in
{
  inherit mkIcon;
}
