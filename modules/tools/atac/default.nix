{ config, lib, pkgs, ... }:

{
	options.tools.atac = {
		enable = lib.mkEnableOption "Enables atac.";
	};

	config = lib.mkIf config.tools.atac.enable {
		home.packages = with pkgs; [
			atac
		];
	};
}
