{ config, lib, pkgs, ... }:

{
	options.tools.brave = {
		enable = lib.mkEnableOption "Enables brave.";
	};

	config = lib.mkIf config.tools.brave.enable {
		home.packages = with pkgs; [
			# Modify the brave-browser.desktop entry to scale the UI
			(brave.overrideAttrs (old: {
				postInstall = (old.postInstall or "") + ''
					sed -i 's|^Exec=\(.*brave[^\n]*\)|Exec=\1 --force-device-scale-factor=1.2|' \
						$out/share/applications/brave-browser.desktop
				'';
			}))
		];

		home.sessionPath = [
			"${config.home.homeDirectory}/.local/bin"
		];

		home.file.".local/bin/brave" = {
			text = ''
#!/bin/sh
exec ${pkgs.brave}/bin/brave --force-device-scale-factor=1.2 "$@"
'';
			executable = true;
		};
	};
}
