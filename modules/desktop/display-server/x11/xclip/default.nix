{ lib, config, pkgs, ... }:

{
	options.desktop.display-server.x11.xclip = {
		enable = lib.mkEnableOption "Enables xclip.";
	};

	config = lib.mkIf config.desktop.display-server.x11.xclip.enable {
		home.packages = with pkgs; [
			xclip
		];
	};
}
