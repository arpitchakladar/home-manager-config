{ config, lib, pkgs, ... }:

{
	options.tools.libreoffice = {
		enable = lib.mkEnableOption "Enables libreoffice.";
	};

	config = lib.mkIf config.tools.libreoffice.enable {
		home.packages = with pkgs; [
			libreoffice
		];
	};
}
