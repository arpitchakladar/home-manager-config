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

		home.file.".xinitrc" = {
			text = ''
#!/bin/sh

[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
[ -f ~/.profile ] && . ~/.profile
[ -f ~/.xsession ] && . ~/.xsession

exec ${pkgs.bspwm}/bin/bspwm
'';
			executable = true;
		};
	};
}
