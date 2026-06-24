{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.programs.brave.enable {
    programs.brave = {
      package = pkgs.brave;

      commandLineArgs = [
        "--enable-features=BraveUltraDarkTheme"
        "--force-device-scale-factor=1.15"
      ];

      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "mpkodccbngfoacfalldjimigbofkhgjn"; } # Aria2 Explorer
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      ];
    };

    xdg.configFile."BraveSoftware/Brave-Browser/policies/managed/policy.json" = {
      text = builtins.toJSON {
        RestoreOnStartup = 1;
        DefaultNotificationsSetting = 2;
        ForceDarkMode = true;
        DefaultCookiesSetting = 1;
        PasswordManagerEnabled = false;

        ExtensionSettings = {
          "nngceckbapebfimnlniiiahkandclblb" = {
            toolbar_pin = "force_pinned";
          };
          "eimadpbcbfnmbkopoojfekhnkhdbieeh" = {
            toolbar_pin = "force_pinned";
          };
        };
      };
    };

    xdg.configFile."BraveSoftware/Brave-Browser/Default/Preferences" = {
      force = true;
      text = builtins.toJSON {
        brave = {
          darker_mode = true;
          enable_window_closing_confirm = false;
          tabs = {
            vertical_tabs_enabled = true;
            vertical_tabs_collapsed = true;
            vertical_tabs_floating_enabled = false;
            always_hide_tab_close_button = true;
          };
          show_side_panel_button = false;
          ai_chat = {
            show_toolbar_button = false;
          };
          wallet = {
            show_wallet_icon_on_toolbar = false;
          };
        };
        browser = {
          show_full_urls = true;
        };
        credentials_enable_service = false;
        credentials_enable_autosignin = false;
        extensions = {
          pinned_extensions = [
            "nngceckbapebfimnlniiiahkandclblb"
            "eimadpbcbfnmbkopoojfekhnkhdbieeh"
          ];
          ui = {
            developer_mode = true;
          };
        };
        profile = {
          default_content_setting_values = {
            notifications = 2;
          };
        };
      };
    };
  };
}
