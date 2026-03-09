{ config, lib, pkgs, ... }:

{
	options.tools.maim = {
		enable = lib.mkEnableOption "Enables maim.";
	};
	
	config = lib.mkIf config.tools.maim.enable {
		home.packages = with pkgs; [
			maim
		];
	};
}
