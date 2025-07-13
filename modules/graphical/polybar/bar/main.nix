{ config, lib }:

with config.scheme.withHashtag;
let
	largerFontSize = toString (builtins.ceil (config.fonts.size * 9.0 / 8.0));
in {
	width = "100%:-20";
	fixed-center = false;
	height = 35;
	override-redirect = false;
	wm-restack = "bspwm";
	enable-ipc = true;

	border-top-size = 1;
	border-bottom-size = 1;
	border-left-size = 1;
	border-right-size = 1;
	border-color = base03;

	background = base00;
	foreground = base05;

	line-size = 3;
	line-color = base08;

	padding-left = 1;
	padding-right = 1;

	module-margin-left = 1;
	module-margin-right = 1;

	separator = "%{F${base03}}%{T3}│%{T-}%{F-}";

	offset-x = "10";
	offset-y = "10";

	font-0 = "${config.fonts.normal}:pixelsize=${toString config.fonts.size};3";
	font-1 = "${config.fonts.normal}:weight=Bold:pixelsize=${largerFontSize};3";
	font-2 = "${config.fonts.normal}:style=Light:pixelsize=${largerFontSize};2";

	modules-left = "bspwm separator";
	modules-center = "xwindow";
	modules-right = "separator memory cpu battery time date kernel-version";
}
