{ config, lib, ... }:

{
	config.programs.nixvim.plugins.treesitter = lib.mkIf config.tools.nixvim.enable {
		enable = true;
		folding = true;
		settings = {
			highlight = { enable = true; };
			indent = { enable = true; };
		};
	};
}
