{ lib, config, ... }:

{
	options.desktop.display-server.compositor.picom = {
		enable = lib.mkEnableOption "Enables picom.";
	};

	config = lib.mkIf config.desktop.display-server.compositor.picom.enable {
		services.picom.enable = true;
		services.picom.backend = "xrender";
		services.picom.fade = false;
		services.picom.shadow = false;
		services.picom.settings = {
			blur-background = false;
			background = "#000000";
		};
		services.picom.activeOpacity = 0.8;
		services.picom.inactiveOpacity = 0.8;
		services.picom.opacityRules = [
			"70:class_g = 'Polybar'"   # 70% opacity for Polybar
		];
	};
}
