{ config }:
with config.scheme.withHashtag;
{
  format = "{name}";
  on-click = "hyprctl dispatch workspace {name}";
}
