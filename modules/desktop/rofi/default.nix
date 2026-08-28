{
  config,
  lib,
  ...
}:
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
          template =
            builtins.replaceStrings
              [
                "@@rofi-font@@"
                "@@rofi-font-message@@"
              ]
              [
                ''"${config.fonts.normal} Bold ${toString config.fonts.size}"''
                ''"${config.fonts.normal} Bold ${toString (config.fonts.size - 4)}"''
              ]
              (builtins.readFile ./theme.mustache.rasi);
        in
        "${config.scheme {
          inherit template;
          extension = ".rasi";
        }}";
      extraConfig = {
        modi = "drun";
        show-icons = true;
        drun-display-format = "{name}";
        sort = true;
      };
    };
  };
}
