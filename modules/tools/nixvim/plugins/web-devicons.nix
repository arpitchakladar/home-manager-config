{ config, lib, ... }:

{
	config.programs.nixvim.plugins.web-devicons = lib.mkIf config.tools.nixvim.enable {
		enable = true;
	};
}
