{ config, iconColor }:
with config.scheme.withHashtag;
{
  format = "<span foreground='${iconColor}'></span> {percentage}%";
  interval = 2;
}
