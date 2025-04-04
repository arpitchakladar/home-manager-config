{ config, lib, pkgs, ... }:

{
	options.desktop.window-manager.bspwm = {
		enable = lib.mkEnableOption "Enables bspwm.";
	};

	config = lib.mkIf config.desktop.window-manager.bspwm.enable {
		assertions = [
			{
				assertion = config.desktop.window-manager.sxhkd.enable;
				message ="Module desktop.window-manager.bspwm requires desktop.window-manager.sxhkd module to be enabled.";
			}
		];

		desktop.window-manager.default = lib.mkDefault "bspwm";
		desktop.window-manager.command =
			if config.desktop.window-manager.default == "bspwm" then
				"${pkgs.bspwm}/bin/bspwm"
			else lib.mkDefault "";

		xsession.windowManager.bspwm.enable = true;

		xsession.windowManager.bspwm.settings = with config.scheme.withHashtag; {
			window_gap = config.desktop.window-manager.gap;
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

		xsession.windowManager.bspwm.extraConfig = builtins.readFile ./bspwmrc;
	};
}
