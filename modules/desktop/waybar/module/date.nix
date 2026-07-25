{ config }:
with config.scheme.withHashtag;
{
  format = " {:%d/%m/%Y}";
  interval = 60;
}
