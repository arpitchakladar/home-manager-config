{ config }:

with config.scheme.withHashtag;
{
	width = "100%";
	height = 30;
	radius = 3;
	fixed-center = false;

	background = "${base00}";
	foreground = "${base05}";

	line-size = 3;
	line-color = "${base08}";

	border-size = 4;
	padding-left = 2;
	padding-right = 2;

	module-margin-left = 2;
	module-margin-right = 2;

	font-0 = "FiraCode Nerd Font:pixelsize=16;3";

	modules-left = "bspwm";
	modules-center = "xwindow";
	modules-right = "memory cpu battery time date kernel-version";
}
