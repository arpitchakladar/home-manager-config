{ config, pkgs, lib, ... }:

{
	options.tools.nvtop = {
		enable = lib.mkEnableOption "Enables nvtop.";
	};

	config = lib.mkIf config.tools.nvtop.enable {
		home.packages = with pkgs; [
			nvtopPackages.full
		];
	};
}
