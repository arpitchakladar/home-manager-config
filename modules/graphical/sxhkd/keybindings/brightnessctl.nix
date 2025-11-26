{ createKeybindingBase, pkgs, lib }:

let
	brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
in lib.mkMerge [
	(createKeybindingBase
		"XF86MonBrightnessDown"
		"Decrease brightness."
		"${brightnessctl} set 5%-")

	(createKeybindingBase
		"XF86MonBrightnessUp"
		"Increase brightness."
		"${brightnessctl} set +5%")
]
