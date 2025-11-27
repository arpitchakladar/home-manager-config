{ createKeybindingBase, pkgs, lib }:

let
	playerctl = "${pkgs.playerctl}/bin/playerctl";
in lib.mkMerge [
	(createKeybindingBase
		"XF86AudioPlay"
		"Toggle video / audio player."
		"${playerctl} play-pause")
]
