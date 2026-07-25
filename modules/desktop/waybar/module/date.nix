{ config, mkIcon }:
with config.scheme.withHashtag;
let
  iconColor = base0E;
in
{
  format = "${mkIcon iconColor ""}  {:%d/%m/%Y}";
  tooltip-format = "{:%A, %d/%m/%Y}";
  interval = 60;
}
