config:

with config.scheme.withHashtag;
{
	type = "internal/bspwm";

	label-focused = "%index%";
	label-focused-background = "${base01}";
	label-focused-underline = "${base0D}";
	label-focused-padding = 2;

	label-occupied = "%index%";
	label-occupied-padding = 2;

	label-urgent = "%index%!";
	label-urgent-background = "${base08}";
	label-urgent-padding = 2;

	label-empty = "%index%";
	label-empty-foreground = "${base03}";
	label-empty-padding = 2;
}
