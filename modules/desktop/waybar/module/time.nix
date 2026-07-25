{ config, mkIcon }:
with config.scheme.withHashtag;
let
  iconColor = base08;
in
{
  format = "${mkIcon iconColor ""}  {:%I:%M %p}";
  tooltip-format = "{:%H:%M:%S}";
  interval = 30;
}
