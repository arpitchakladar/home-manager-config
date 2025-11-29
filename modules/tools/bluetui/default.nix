{ config, lib, pkgs, ... }:

{
	options.tools.bluetui = {
		enable = lib.mkEnableOption "Enables bluetui.";
	};

	config = lib.mkIf config.tools.bluetui.enable {
		home.packages = with pkgs; [
			bluetui
		];
	};
}
