{ config, lib, pkgs, ... }:

{
	options.tools.librewolf = {
		enable = lib.mkEnableOption "Enables librewolf.";
	};

	config = lib.mkIf config.tools.librewolf.enable {
		programs.librewolf = {
			enable = true;
			package = pkgs.librewolf.override {
				nativeMessagingHosts = [
					pkgs.tridactyl-native
				];
			};
			profiles."arpit" = {
				isDefault = true;
				settings = {
					"extensions.autoDisableScopes" = 0;
					"extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
					"sidebar.verticalTabs" = true;
					"sidebar.visibility" = "always-show";
					"sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
					"layout.css.devPixelsPerPx" = 1.1;
					"layout.css.prefers-color-scheme.content-override" = 0; # Dark
					"browser.toolbars.bookmarks.visibility" = "newtab";
					"browser.startup.homepage"
						= "moz-extension://8cb32547-41c0-4839-bec4-a4c08b4d267b/static/newtab.html"; # Tridactyl
					"browser.startup.page" = 2;
					"sidebar.expandOnHover" = false;
					"sidebar.animation.enabled" = false;
				};
			};
			policies = {
				ExtensionSettings = {
					"uBlock0@raymondhill.net" = {
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
						installation_mode = "force_installed";
						private_browsing = true;
					};
					"{9b84b6b4-07c4-4b4b-ba21-394d86f6e9ee}" = {
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/black21/latest.xpi";
						installation_mode = "force_installed";
					};
					"tridactyl.vim@cmcaine.co.uk" = {
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
						installation_mode = "force_installed";
					};
					"{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
						default_area = "menupanel";
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
						installation_mode = "force_installed";
					};
				};
			};
		};
	};
}
