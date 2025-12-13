{ pkgs, config, lib, ... }:

{
	config = lib.mkIf config.tools.nixvim.enable {
		programs.nixvim.keymaps = [
			{ key = "<c-h>"; action = "<c-w>h"; }
			{ key = "<c-w>"; action = "<c-w>j"; }
			{ key = "<c-k>"; action = "<c-w>k"; }
			{ key = "<c-l>"; action = "<c-w>l"; }
			{
				key = "<c-n>";
				action = "<cmd>NvimTreeToggle<cr>";
				mode = [ "n" "i" ];
			}
			{ key = "<c-c>"; action = "<cmd>NotificationsClear<cr>"; }
		];
	};
}
