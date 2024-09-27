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
		in lib.mkMerge [
			(
				if config.desktop.window-manager.bspwm.enable then
					(import ./keybindings/bspwm.nix { inherit pkgs createKeybinding; })
				else {}
			)
			{
				${(createKeybinding
					"s"
					"Show keybindings.")}
						= pkgs.writeShellScript
							"keybindings.sh"
							(builtins.readFile ./scripts/keybindings.sh);

				${(createKeybinding
					"r"
					"Application launcher.")}
						= config.desktop.popup-manager.application-launcher.command;

				${(createKeybinding
					"t"
					"Launch terminal.")}
						= config.desktop.terminal.command;

				${(createKeybinding
					"f"
					"Launch File Manager.")}
						= "${config.desktop.terminal.command} --title 'File Manager' --class popup -e ${config.tools.file-manager.command}";
			}
		];
	};
}
