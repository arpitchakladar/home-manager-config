{ config, pkgs, lib, ... }:

{
	options.tools.bottles = {
		enable = lib.mkEnableOption "Enables bottles.";
	};

	config = lib.mkIf config.tools.bottles.enable {
		home.packages = with pkgs; [
			(bottles.override {
				removeWarningPopup = true;
			})
		];
	};
}
