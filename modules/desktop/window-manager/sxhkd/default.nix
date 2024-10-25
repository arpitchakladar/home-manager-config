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
			createKeybinding = keybinding: description: command: {
				"# ${description}\n${modKey} + ${keybinding}" = command;
			};
		in lib.mkMerge [
			(
				if config.desktop.window-manager.bspwm.enable then
					(import ./keybindings/bspwm.nix { inherit pkgs createKeybinding lib; })
				else {}
			)
			(lib.mkMerge [
				(createKeybinding
					"s"
					"Show keybindings."
					(pkgs.writeShellScript "keybindings.sh" (builtins.readFile ./scripts/keybindings.sh)))

				(createKeybinding
					"r"
					"Application launcher."
					config.desktop.application-launcher.command)

				(createKeybinding
					"t"
					"Launch terminal."
					config.tools.terminal.command)

				(createKeybinding
					"f"
					"Launch File Manager."
					"${config.tools.terminal.command} --title 'File Manager' --class floating-termial -e ${config.tools.file-manager.command}")
			])
		];
	};
}
