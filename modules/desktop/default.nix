{ lib, config, pkgs, ... }:

{
	imports = [
		./bspwm
		./polybar
		./sxhkd
	];

	options.desktop = {
		enable = lib.mkEnableOption "Enables graphical interface.";
	};

	config = lib.mkIf config.desktop.enable {
		xdg.enable = true;
		xsession.enable = true;

		xsession.windowManager.command = lib.mkForce "
#!/bin/sh
${if config.tools.feh.enable then
	"${pkgs.feh}/bin/feh --bg-scale ${../../assets/skeleton-mage.png}"
else "xsetroot -solid \"${config.scheme.withHashtag.base00}\""}
pkill sxhkd
sxhkd &
exec ${pkgs.bspwm}/bin/bspwm
";
	};
}
