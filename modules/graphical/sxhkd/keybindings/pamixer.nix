{ createKeybindingBase, pkgs, lib }:

let
	pamixer = "${pkgs.pamixer}/bin/pamixer";
in lib.mkMerge [
	(createKeybindingBase
		"XF86AudioLowerVolume"
		"Decrease volume."
		"${pamixer} --decrease 5")

	(createKeybindingBase
		"XF86AudioRaiseVolume"
		"Increase volume."
		"${pamixer} --increase 5")

	(createKeybindingBase
		"XF86AudioMute"
		"Mute audio."
		"${pamixer} --toggle-mute")
]
