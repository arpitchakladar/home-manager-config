{ config, iconColor }:
with config.scheme.withHashtag;
{
  format = "<span foreground='${iconColor}'></span>  {:%I:%M %p}";
  tooltip-format = "{:%H:%M:%S}";
  interval = 30;
}
