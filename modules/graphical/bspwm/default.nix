{ config, lib, pkgs, ... }:

{
	config = lib.mkIf config.graphical.enable {
		xsession.windowManager.bspwm.enable = true;

		xsession.windowManager.bspwm.settings = with config.scheme.withHashtag; {
			window_gap = 10;
			split_ratio = 0.5;
			single_monocle = true;
			borderless_monocle = false;
			gapless_monocle = false;
			focus_follows_pointer = true;
			pointer_follows_focus = false;
			pointer_motion_interval = 40;
			pointer_modifier = "mod1"; # alt key
			pointer_action1 = "resize_side";
			pointer_action2 = "move";
			pointer_action3 = "resize_corner";
			normal_border_color = base02;
			active_border_color = base02;
			focused_border_color = base03;
		};

		xsession.windowManager.bspwm.rules = {
			"floating-termial" = {
				state = "floating";
				sticky = true;
				rectangle = "1000x600+0+0";
				center = true;
				follow = true;
			};
		};

		xsession.windowManager.bspwm.extraConfig = ''
for monitor in $(xrandr -q | grep -w 'connected' | cut -d' ' -f1); do
	bspc monitor "$monitor" -d '1' '2' '3' '4' '5' '6'
done
		'';
	};
}
