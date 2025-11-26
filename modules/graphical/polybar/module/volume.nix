{ config }:

with config.scheme.withHashtag;
{
	type = "internal/pulseaudio";
	interval = 5;
	format-volume = "<ramp-volume> <label-volume>";
	label-volume = "%percentage%%";
	label-muted = " ";
	ramp-volume-0 = " ";
	ramp-volume-1 = " ";
	ramp-volume-2 = " ";
}
