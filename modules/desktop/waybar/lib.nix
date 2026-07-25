{ lib, ... }:
let
  mkIcon = color: icon: "<span foreground='${color}' font_size='125%'>${icon}</span>";
in
{
  inherit mkIcon;
}
