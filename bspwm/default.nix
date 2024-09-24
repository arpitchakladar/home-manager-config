{ config, ... }:

{
	xsession.windowManager.bspwm.enable = true;

	xsession.windowManager.bspwm.settings = with config.scheme.withHashtag; {
		window_gap = 5;
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
		"popup" = {
			state = "floating";
			sticky = true;
		};
	};

	xsession.windowManager.bspwm.extraConfig = builtins.readFile ./bspwmrc;
}
