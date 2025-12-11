{ config, lib, ... }:

{
	config.programs.nixvim.plugins.noice = lib.mkIf config.tools.nixvim.enable {
		enable = true;
		cmdline = {
			enabled = true;
			view = "cmdline_popup";
		};
		popupmenu = {
			enabled = true;
			backend = "cmp";
		};
		presets = {
			command_palette = true;
		};
	};
}
