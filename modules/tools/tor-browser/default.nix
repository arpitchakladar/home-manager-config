{ pkgs, lib, config, ... }:

{
	options.tools.tor-browser = {
		enable = lib.mkEnableOption "Enables tor-browser.";
	};
	
	config = lib.mkIf config.tools.tor-browser.enable {
		home.packages = with pkgs; [
			tor-browser
		];
	};
}
