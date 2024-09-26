{ pkgs, config, lib, ... }:

{
	options.desktop.xdg-portal = {
		enable = lib.mkEnableOption "Enables xdg desktop portal.";
	};

	config = lib.mkIf config.desktop.xdg-portal.enable {
		xdg.portal.enable = true;
		xdg.portal.xdgOpenUsePortal = true;

		xdg.portal.config = {
			common = {
				default = [
					"gtk"
				];
			};
		};

		xdg.portal.extraPortals = [
			pkgs.xdg-desktop-portal-gtk
		];
	};
}
