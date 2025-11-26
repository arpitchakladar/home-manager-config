{ config, lib, pkgs, ... }:

{
	config = lib.mkIf config.graphical.enable {
		services.polybar.enable = true;
		services.polybar.package = (pkgs.polybar.override {
			pulseSupport = true;
		});
		services.polybar.script = "${config.services.polybar.package}/bin/polybar main &";
		services.polybar.config = lib.mkMerge [
			(import ./bar { inherit config lib; })
			(import ./module { inherit config lib; })
			{
				settings = {
					screenchange-reload = true;
				};
			}
		];
	};
}
