{ pkgs, config, lib, ... }:

{
	options.desktop.window-manager.sxhkd = {
		enable = lib.mkEnableOption "Enables sxhkd.";
	};

	config = lib.mkIf config.desktop.window-manager.sxhkd.enable {
		services.sxhkd.enable = true;

		services.sxhkd.keybindings =
		let
			modKey = "alt";
			createKeybinding = keybinding: description: "# ${description}\n${modKey} + ${keybinding}";
		in {
			${(createKeybinding
				"s"
				"Show keybindings.")}
					= pkgs.writeShellScript
						"show-keybindings.sh"
						(builtins.readFile ./scripts/show-keybindings.sh);

			${(createKeybinding
				"r"
				"Launch rofi.")}
					= "rofi -show run";

			${(createKeybinding
				"t"
				"Launch terminal.")}
					= config.desktop.terminal.default;

			${(createKeybinding
				"f"
				"Launch File Explorer.")}
					= "${config.desktop.terminal.default} -t 'File Explorer' --class 'popup' -e lf";

			${(createKeybinding
				"q"
				"Kill current window.")}
					= "bspc node -c";

			${(createKeybinding
				"{1-9,0}"
				"Switch workspace.")}
					= "bspc desktop -f {1-9,10}";

			${(createKeybinding
				"shift + {1-9,0}"
				"Move window to workspace.")}
					= "bspc node -d {1-9,10} --follow";

			${(createKeybinding
				"{n,d,m}"
				"Set current window mode (tiled, floating, fullscreen).")}
					= "bspc node focused -t {tiled,floating,fullscreen}";

			${(createKeybinding
				"{_,shift + }{h,j,k,l}"
				"Navigate between windows.")}
					= "bspc node --{focus,swap} {west,south,north,east}";

			# the indentation for each line is required to work with the help prompt
			${(createKeybinding
				"ctrl + {h,j,k,l}"
				"Resize current window.")}
					= ''
					{bspc node @parent/second -z left -20 0; \
					bspc node @parent/first -z right -20 0, \
					bspc node @parent/second -z top 0 +20; \
					bspc node @parent/first -z bottom 0 +20, \
					bspc node @parent/first -z bottom 0 -20; \
					bspc node @parent/second -z top 0 -20, \
					bspc node @parent/first -z right +20 0; \
					bspc node @parent/second -z left +20 0}
			'';
		};
	};
}
