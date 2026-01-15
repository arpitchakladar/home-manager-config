{ config, pkgs, lib, ... }:

{
	options.tools.devenv = {
		enable = lib.mkEnableOption "Enables devenv.";
	};

	config = lib.mkIf config.tools.devenv.enable {
		home.packages = with pkgs; [
			devenv
		];
	};
}
