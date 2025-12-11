{ config, lib, ... }:

{
	config.programs.nixvim.plugins.which-key = lib.mkIf config.tools.nixvim.enable {
		enable = true;
		settings = {
			plugins = {
				marks = true;
				registers = true;
				spelling = { enabled = true; suggestions = 20; };
			};
			win = { border = "single"; };
		};
	};
}
