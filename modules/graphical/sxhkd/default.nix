{ pkgs, config, lib, ... }:

{
	config = lib.mkIf config.graphical.enable {
		services.sxhkd.enable = true;
		services.sxhkd.keybindings =
		let
			modKey = "alt";
			createKeybinding = keybinding: description: command: {
				"# ${description}\n${modKey} + ${keybinding}" = command;
			};
		in lib.mkMerge [
			(import ./keybindings/bspwm.nix { inherit pkgs createKeybinding lib; })

			(createKeybinding
				"s"
				"Show keybindings."
				"kitty --title 'Keybindings' --class floating-termial -e ${pkgs.writeShellScript "keybindings.sh" (builtins.readFile ./scripts/keybindings.sh)}"
				)

			(createKeybinding
				"r"
				"Application launcher."
				"rofi")

			(createKeybinding
				"t"
				"Launch terminal."
				"kitty")

			# (createKeybinding
			# 	"f"
			# 	"Launch File Manager."
			# 	"kitty --title 'File Manager' --class floating-termial -e ${config.tools.file-manager.command}")
		];
	};
}
