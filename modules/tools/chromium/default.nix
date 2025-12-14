{ config, lib, pkgs, ... }:

{
	imports = [
		./extensions.nix
	];

	options.tools.chromium = {
		enable = lib.mkEnableOption "Enables chromium (with brave).";
	};

	config = lib.mkIf config.tools.chromium.enable {
		programs.chromium = {
			enable = true;
			package = pkgs.brave;
			commandLineArgs = [
				"--force-device-scale-factor=1.2"
			];
		};
	};
}
