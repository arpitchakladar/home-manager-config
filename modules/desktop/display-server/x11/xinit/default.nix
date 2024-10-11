{ lib, config, pkgs, ... }:

{
	options.desktop.display-server.x11.xinit = {
		enable = lib.mkEnableOption "Enables xinit.";
	};

	config = lib.mkIf config.desktop.display-server.x11.xinit.enable {
		home.file.".xinitrc" = {
			executable = true;
			source = pkgs.writeText ".xinitrc"
''
#!/bin/sh
xsetroot -solid "${config.scheme.withHashtag.base00}"
${if config.desktop.display-server.compositor.picom.enable then
	"picom &"
else ""}
${if config.tools.viewer.feh.enable then
	"feh --bg-scale ${../../../../../assets/skeleton-mage.png}"
else ""}
${if config.desktop.status-bar.polybar.enable then
	config.desktop.status-bar.polybar.command
else ""}
${if config.desktop.window-manager.sxhkd.enable then "sxhkd &" else ""}
exec ${config.desktop.window-manager.default}
'';
		};
	};
}
