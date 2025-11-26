{ config, lib, pkgs, ... }:

{
	options.tools.acpi = {
		enable = lib.mkEnableOption "Enables acpi.";
	};

	config = lib.mkIf config.tools.acpi.enable {
		home.packages = [
			pkgs.acpi
		];
	};
}
