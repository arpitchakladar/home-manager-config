{ ... }:

{
	xsession.windowManager.bspwm.enable = true;

	xsession.windowManager.bspwm.settings = {
		window_gap = 5;
		split_ratio = 0.5;
		single_monocle = true;
		borderless_monocle = false;
		gapless_monocle = false;
		focus_follows_pointer = true;
		pointer_follows_focus = false;
		pointer_motion_interval = 60;
		pointer_modifier = "mod4";
		pointer_action1 = "move";
		pointer_action2 = "resize_side";
		pointer_action3 = "resize_corner";
	};

	xsession.windowManager.bspwm.rules = {
		"File Explorer" = {
			state = "floating";
			sticky = true;
		};
	};

	xsession.windowManager.bspwm.extraConfig = builtins.readFile ./bspwmrc;
}
