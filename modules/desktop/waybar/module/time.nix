{ config, iconColor }:
with config.scheme.withHashtag;
{
  format = "<span foreground='${iconColor}'></span> {:%I:%M %p}";
  interval = 30;
}
