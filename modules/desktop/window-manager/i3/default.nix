{ config, lib, pkgs, ... }:

{
	options.desktop.window-manager.i3 = {
		enable = lib.mkEnableOption "Enables i3.";
	};

	config = lib.mkIf config.desktop.window-manager.i3.enable {
		# Set i3 as the default window manager
		desktop.window-manager.default = lib.mkDefault "i3";
		desktop.window-manager.command =
			if config.desktop.window-manager.default == "i3" then
				"${pkgs.i3}/bin/i3"
			else lib.mkDefault "";

		xsession.windowManager.i3.enable = true;

		xsession.windowManager.i3.config = {
			modifier = "Mod4";
			gaps = {
				inner = config.desktop.window-manager.gap;
			};
			terminal = config.tools.terminal.command;
			fonts = {
				names = [ "FiraCode Nerd Font" ];
				size = 11.0;
			};
			bars = [
				{
					command =
						lib.mkIf
							config.desktop.status-bar.polybar.enable
							config.desktop.status-bar.polybar.command;
				}
			];
		};
	};
}
