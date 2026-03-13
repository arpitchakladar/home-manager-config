{ config }:

with config.scheme.withHashtag;
{
  type = "internal/i3";

  label-focused = "%index%";
  label-focused-underline = "${base0D}";
  label-focused-padding = 1;

  label-unfocused = "%index%";
  label-unfocused-padding = 1;

  label-occupied = "%index%";
  label-occupied-padding = 1;

  label-urgent = "%index%";
  label-urgent-underline = "${base08}";
  label-urgent-padding = 1;

  label-empty = "%index%";
  label-empty-foreground = "${base03}";
  label-empty-padding = 1;

  pin-workspaces = true;
  index-sort = true;
  show-all = true;
}
