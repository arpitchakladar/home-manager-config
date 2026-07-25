{ config }:
with config.scheme.withHashtag;
{
  format = "{name}";
  persistent-workspaces = {
    "*" = 10;
  };
  on-click = "hyprctl dispatch workspace {name}";
}
