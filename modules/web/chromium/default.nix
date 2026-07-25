# Chromium - Web browser configuration
{
  config,
  lib,
  ...
}:
{
  imports = [
    ./browserpass.nix
  ];

  options.web.chromium = {
    enable = lib.mkEnableOption "Enables chromium.";
    package = lib.mkOption {
      type = lib.types.package;
      default = config.programs.chromium.finalPackage;
      defaultText = lib.literalExpression "config.programs.chromium.finalPackage";
      description = "Package to use for chromium. Defaults to the wrapped finalPackage from programs.chromium.";
    };
  };

  config = lib.mkIf config.web.chromium.enable {
    programs.chromium = {
      enable = true;

      commandLineArgs = [
        "--force-device-scale-factor=1.15"
      ];

      extensions = [
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
        { id = "naepdomgkenhinolocfifgehidddafch"; } # Browserpass
        { id = "kioklelcojgbjoljlilalgdcppkiioge"; } # Quite Black
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
        { id = "hpejmncgbammabkkodflfeekpcicfjnk"; } # Aria2 Explorer
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
        browser = {
          show_full_urls = true;
          theme = {
            follows_system_colors = true;
          };
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
          pinned_extensions = [
            "ddkjiahejlhfcafbddmgiahcphecmpfh"
            "naepdomgkenhinolocfifgehidddafch"
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
        high_efficiency_mode_enabled = true;
      };
    };
  };
}
