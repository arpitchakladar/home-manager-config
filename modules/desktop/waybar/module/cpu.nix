{ config, iconColor }:
with config.scheme.withHashtag;
{
  format = "<span foreground='${iconColor}'></span>  {usage}%";
  interval = 2;
}
