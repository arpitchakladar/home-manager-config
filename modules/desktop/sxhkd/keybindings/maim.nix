{ createKeybinding, pkgs, lib }:

let
	maim = "${pkgs.maim}/bin/maim";
in lib.mkMerge [
	(createKeybinding
		"Print"
		"Take screenshot of selected area and save to clipboard"
		"${maim} -s | xclip -selection clipboard -t image/png")

	(createKeybinding
		"Shift + Print"
		"Take screenshot of selected area and save to ~/Pictures/Screenshots"
		"mkdir -p ~/Pictures/Screenshots && ${maim} -s ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png")
]
