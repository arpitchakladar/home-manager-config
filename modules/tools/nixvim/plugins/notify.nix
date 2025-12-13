{ config, lib, ... }:

{
	config.programs.nixvim.plugins.notify = lib.mkIf config.tools.nixvim.enable {
		enable = false;
	};
}
