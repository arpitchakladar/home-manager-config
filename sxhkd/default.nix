{ ... }:

{
	services.sxhkd.enable = true;

	services.sxhkd.keybindings = {
		"super + r" = "rofi -show run";
		"super + t" = "alacritty";
		"super + f" = "alacritty -t 'File Explorer' --class 'File Explorer' -e lf";
		"super + q" = "bspc node -c";

		# switch desktops
		"super + {1-9,0}" = "bspc desktop -f {1-9,10}";

		# move window to desktop
		"super + shift + {1-9,0}" = "bspc node -d {1-9,10} --follow";

		# tiled
		"super + n" = "bspc node focused -t tiled";

		# floating
		"super + d" = "bspc node focused -t floating";

		# fullscreen
		"super + m" = "bspc node focused -t fullscreen";

		# resize windows
		"super + alt + {h,j,k,l}" = ''
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
