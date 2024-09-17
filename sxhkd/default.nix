{ ... }:

{
	services.sxhkd = {
		enable = true;
		keybindings = {
			"super + r" = "rofi -show run";
			"super + t" = "alacritty";
			"super + q" = "bspc node -c";
			"super + {1-9,0}" = "bspc desktop -f {1-9,10}";
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
	};
}
