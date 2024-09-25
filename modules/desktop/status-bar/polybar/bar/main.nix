{ config }:

with config.scheme.withHashtag;
{
	width = "\${env:POLYBAR_WIDTH}";
	fixed-center = false;
	height = 35;

	border-top-size = 1;
	border-bottom-size = 1;
	border-left-size = 1;
	border-right-size = 1;
	border-color = base02;

	background = base00;
	foreground = base05;

	line-size = 3;
	line-color = base08;

	padding-left = 1;
	padding-right = 1;

	module-margin-left = 2;
	module-margin-right = 2;

	offset-x = "\${env:POLYBAR_OFFSET}";
	offset-y = "\${env:POLYBAR_OFFSET}";

	font-0 = "FiraCode Nerd Font:pixelsize=16;3";

	modules-left =
		if config.desktop.window-manager.bspwm.enable then
			"bspwm"
		else null;
	modules-center = "xwindow";
	modules-right = "memory cpu battery time date kernel-version";
}
