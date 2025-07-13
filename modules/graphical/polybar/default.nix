{ config, lib, pkgs, ... }:

{
	config = lib.mkIf config.graphical.enable {
		services.polybar.enable = true;
		home.packages = with pkgs; [
			coreutils
		];
		services.polybar.script = "
export PATH=${pkgs.coreutils}/bin/:$PATH
${config.services.polybar.package}/bin/polybar main &
";
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
