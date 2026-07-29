{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./browserpass.nix
    ./extensions/assertions.nix
  ];

  options.web.chromium = {
    enable = lib.mkEnableOption "Enables chromium.";
    package = lib.mkOption {
      type = lib.types.package;
      default = config.programs.chromium.finalPackage;
      defaultText = lib.literalExpression "config.programs.chromium.finalPackage";
      description = "Package to use for chromium. Defaults to the wrapped finalPackage from programs.chromium.";
    };
    checkForUpdates = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Check GitHub for newer extension releases before building, and abort
        with upgrade instructions if the pinned version is stale. Requires
        network access during evaluation (pass --impure to nix/home-manager).
      '';
    };
  };

  config = lib.mkIf config.web.chromium.enable (
    let
      exts = import ./extensions {
        inherit lib pkgs config;
        checkForUpdates = config.web.chromium.checkForUpdates;
      };

      extensionDirs = [
        exts.aria2Explorer.drv
        exts.browserpass.drv
        exts.darkMode.drv
        exts.searxngHome.drv
        exts.theme.drv
        exts.ublockOrigin.drv
      ];

      pinnedIds = lib.filter (id: id != null) [
        exts.browserpass.id
        exts.darkMode.id
        exts.ublockOrigin.id
      ];
    in
    {
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
        commandLineArgs = [
          "--force-device-scale-factor=1.15"
          "--load-extension=${lib.concatStringsSep "," extensionDirs}"
        ];
      };

      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/http" = "chromium-browser.desktop";
        "x-scheme-handler/https" = "chromium-browser.desktop";
        "x-scheme-handler/chrome" = "chromium-browser.desktop";
        "text/html" = "chromium-browser.desktop";
        "application/xhtml+xml" = "chromium-browser.desktop";
      };

      xdg.configFile."chromium/Default/Preferences" = {
        force = true;
        text = builtins.toJSON {
          NewTabPage = {
            FooterVisible = false;
          };
          bookmark_bar = {
            show_on_all_tabs = false;
          };
          browser = {
            show_full_urls = true;
            theme = {
              follows_system_colors = true;
            };
          };
          search = {
            suggest_enabled = false;
          };
          url_handling = {
            show_full_urls = true;
          };
          autofill = {
            profile_enabled = false;
            credit_card_enabled = false;
          };
          vertical_tabs = {
            collapsed_state = true;
            enabled = true;
            enabled_first_time = true;
            uncollapsed_width = 240;
          };
          credentials_enable_service = false;
          credentials_enable_autosignin = false;
          extensions = {
            pinned_extensions = pinnedIds;
            ui = {
              developer_mode = true;
            };
          };
          profile = {
            default_content_setting_values = {
              notifications = 2;
            };
          };
          high_efficiency_mode_enabled = true;
        };
      };
    }
  );
}
