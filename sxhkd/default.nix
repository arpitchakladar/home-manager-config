{ ... }:

{
	services.sxhkd.enable = true;

	services.sxhkd.keybindings =
	let
		withDescription = keybinding: description: "# ${description}\n${keybinding}";
	in {
		${(withDescription
			"super + h"
			"Show keybindings.")} = ''awk '/^#/{desc=substr($0, 3)} /^[a-z]/ { cmd=$0; print cmd " : " desc }' ~/.config/sxhkd/sxhkdrc | rofi -dmenu -i -p "Keybindings"'';

		${(withDescription
			"super + r"
			"Launch rofi.")} = "rofi -show run";

		${(withDescription
			"super + t"
			"Launch terminal.")} = "alacritty";

		${(withDescription
			"super + f"
			"Launch File Explorer.")} = "alacritty -t 'File Explorer' --class 'File Explorer' -e lf";

		${(withDescription
			"super + q"
			"Kill current window.")} = "bspc node -c";

		# switch desktops
		${(withDescription
			"super + {1-9,0}"
			"Switch workspace.")} = "bspc desktop -f {1-9,10}";

		# move window to desktop
		${(withDescription
			"super + shift + {1-9,0}"
			"Move window to workspace.")} = "bspc node -d {1-9,10} --follow";

		# tiled
		${(withDescription
			"super + n"
			"Set current window to tiled mode.")} = "bspc node focused -t tiled";

		# floating
		${(withDescription
			"super + d"
			"Set current window to floating mode.")} = "bspc node focused -t floating";

		# fullscreen
		${(withDescription
			"super + m"
			"Set current window to full screen mode.")} = "bspc node focused -t fullscreen";

		# resize windows (the indentation for each line is required to work with the help prompt)
		${(withDescription
			"super + alt + {h,j,k,l}"
			"Resize current window.")} = ''
				{bspc node @parent/second -z left -20 0; \
				bspc node @parent/first -z right -20 0, \
				bspc node @parent/second -z top 0 +20; \
				bspc node @parent/first -z bottom 0 +20, \
				bspc node @parent/first -z bottom 0 -20; \
				bspc node @parent/second -z top 0 -20, \
				bspc node @parent/first -z right +20 0; \
				bspc node @parent/second -z left +20 0}
		'';
	};
}
