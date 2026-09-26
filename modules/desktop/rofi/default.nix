# Application launcher, dmenu replacement and action menu
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

    action = {
      actions = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                description = "Name shown in the menu.";
              };
              command = lib.mkOption {
                type = lib.types.str;
                description = "Shell command to run when the entry is selected.";
              };
              icon = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Icon name shown next to the entry.";
              };
            };
          }
        );
        default = [ ];
        description = "Actions shown by the rofi-action menu.";
      };

      package = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        description = "The rofi-action script package.";
      };
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

    home.packages = lib.mkIf (cfg.action.actions != [ ]) [ cfg.action.package ];

    desktop.rofi.action.package = pkgs.writeShellApplication {
      name = "rofi-action";
      runtimeInputs = [
        config.terminal.bash.package
        cfg.package
      ];
      text =
        let
          actions = cfg.action.actions;
          optionsString = lib.concatMapStringsSep "\\n" (
            action: action.name + lib.optionalString (action.icon != null) "\\0icon\\x1f${action.icon}"
          ) actions;
          casesString = lib.concatStringsSep "\n" (
            map (action: "    \"${action.name}\") ${action.command} ;;") actions
          );
        in
        builtins.replaceStrings
          [
            "@@OPTIONS@@"
            ''"@@CASES@@") : ;;''
          ]
          [ optionsString casesString ]
          (builtins.readFile ./rofi-action.sh);
    };
  };
}
