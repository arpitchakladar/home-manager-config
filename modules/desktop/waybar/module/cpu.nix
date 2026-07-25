{ config }:
with config.scheme.withHashtag;
{
  format = " {usage}%";
  interval = 2;
}
