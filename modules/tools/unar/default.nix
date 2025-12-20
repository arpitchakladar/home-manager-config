{ pkgs, lib, config, ... }:

{
	options.tools.unar = {
		enable = lib.mkEnableOption "Enables unar.";
	};

	config = lib.mkIf config.tools.unar.enable {
		home.packages = with pkgs; [
			unar
		];
	};
}
