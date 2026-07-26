{ config, mkIcon, ... }:
with config.scheme.withHashtag;
let
  iconColor = base0D;
in
{
  format = "${mkIcon iconColor ""}  {usage}%";
  interval = 2;
}
