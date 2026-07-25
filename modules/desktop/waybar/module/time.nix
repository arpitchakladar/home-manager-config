{ config }:
with config.scheme.withHashtag;
{
  format = " {:%I:%M %p}";
  interval = 30;
}
