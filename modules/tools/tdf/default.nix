{ config, pkgs, lib, ... }:

{
	options.tools.tdf = {
		enable = lib.mkEnableOption "Enables tdf.";
	};

	config = lib.mkIf config.tools.tdf.enable {
		home.packages = with pkgs; [
			tdf
		];
	};
}
