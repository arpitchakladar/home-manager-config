{ ... }:

{
	xsession.windowManager.bspwm = {
		enable = true;
		settings = {
			window_gap = 5;
			split_ratio = 0.51;
			single_monocle = true;
			borderless_monocle = false;
			gapless_monocle = false;
			focus_follows_pointer = true;
			pointer_follows_focus = false;
			pointer_motion_interval = 5;
			pointer_modifier = "mod4";
			pointer_action1 = "move";
			pointer_action2 = "resize_side";
			pointer_action3 = "resize_corner";
		};
		extraConfig = builtins.readFile ./bspwmrc;
	};
}
