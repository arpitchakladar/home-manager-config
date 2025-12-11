{ config, lib, ... }:

{
	config.programs.nixvim.plugins.comment = lib.mkIf config.tools.nixvim.enable {
		enable = true;
	};
}
