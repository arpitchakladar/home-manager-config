{ config, lib, pkgs, ... }:

{
	options.tools.vlc = {
		enable = lib.mkEnableOption "Enables vlc.";
	};

	config = lib.mkIf config.tools.vlc.enable {
		home.packages = with pkgs; [
			vlc
		];
	};
}
