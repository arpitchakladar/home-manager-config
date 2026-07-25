{ config }:
with config.scheme.withHashtag;
{
  format = " {usedGb} GB";
  interval = 2;
}
