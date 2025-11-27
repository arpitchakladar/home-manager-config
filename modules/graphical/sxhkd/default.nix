{ pkgs, config, lib, ... }:

{
	config = lib.mkIf config.graphical.enable {
		services.sxhkd.enable = true;
		services.sxhkd.keybindings =
		let
			modKey = "super";
			createKeybinding = keybinding: createKeybindingBase "${modKey} + ${keybinding}";
			createKeybindingBase = keybinding: description: command: {
				"# ${description}\n${keybinding}" = command;
			};
		in lib.mkMerge [
			(import ./keybindings/brightnessctl.nix { inherit pkgs createKeybindingBase lib; })
			(import ./keybindings/bspwm.nix { inherit pkgs createKeybinding lib; })
			(import ./keybindings/pamixer.nix { inherit pkgs createKeybindingBase lib; })
			(import ./keybindings/playerctl.nix { inherit pkgs createKeybindingBase lib; })

			(createKeybinding
				"s"
				"Show keybindings."
				"kitty --title 'Keybindings' --class floating-termial -e ${pkgs.writeShellScript "keybindings.sh" (builtins.readFile ./scripts/keybindings.sh)}"
				)

			(createKeybinding
				"r"
				"Application launcher."
				"rofi -show drun")

			(createKeybinding
				"t"
				"Launch terminal."
				"kitty")

			(createKeybinding
				"f"
				"Launch File Manager."
				"kitty --title 'File Manager' --class floating-termial -e nnn")
		];
	};
}
