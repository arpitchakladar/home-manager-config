{ config, pkgs, lib, ... }:

{
	options.tools.systemctl-tui = {
		enable = lib.mkEnableOption "Enables systemctl-tui.";
	};

	config = lib.mkIf config.tools.systemctl-tui.enable {
		home.packages = with pkgs; [
			systemctl-tui
		];
	};
}
