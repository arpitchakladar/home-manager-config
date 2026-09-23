# Application launcher and dmenu replacement
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.rofi;
  base16Colors = import ../../colors/base16 { inherit config lib pkgs; };
in
{
  options.desktop.rofi = {
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.rofi.finalPackage;
      description = "The rofi package to use.";
    };
  };

  config = lib.mkIf config.desktop.enable {
    programs.rofi = {
      enable = true;
      theme =
        let
          fontExpandedThemeTemplate =
            builtins.replaceStrings
              [
                "@@rofi-font@@"
                "@@rofi-font-message@@"
              ]
              [
                ''"${config.fonts.normal} Bold ${toString config.fonts.size}"''
                ''"${config.fonts.normal} Bold ${toString config.fonts.idx-size}"''
              ]
              (builtins.readFile ./theme.rasi);
        in
        "${base16Colors {
          templateFileOrContent = fontExpandedThemeTemplate;
          fileExtension = ".rasi";
        }}";
      settings = {
        modi = "drun";
        show-icons = true;
        drun-display-format = "{name}";
        sort = true;
      };
    };
  };
}
