{ config, iconColor }:
with config.scheme.withHashtag;
{
  format = "<span foreground='${iconColor}'></span> {:%d/%m/%Y}";
  interval = 60;
}
