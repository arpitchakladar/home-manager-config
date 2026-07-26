{ config, mkIcon, ... }:
with config.scheme.withHashtag;
let
  iconColor = base0F;
in
{
  format = "${mkIcon iconColor ""}  {percentage}%";
  interval = 2;
}
