# Terminal file manager with native previews
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.file-management.yazi;

  yaziFileChooserScript = pkgs.writeShellApplication {
    name = "yazi-file-chooser";
    runtimeInputs = [
      config.terminal.bash.package
      cfg.package
      config.terminal.kitty.package
    ];
    text = builtins.readFile ./file-chooser.sh;
  };
in
{
  imports = [
    ./theme.nix
    ./assertions.nix
  ];

  options.file-management.yazi = {
    enable = lib.mkEnableOption "Enables yazi.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.yazi.finalPackage;
      defaultText = lib.literalExpression "config.programs.yazi.finalPackage";
      description = "The yazi package to use. Defaults to the wrapped finalPackage from programs.yazi.";
    };

    file-chooser = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Enables the yazi-file-chooser script.";
          package = lib.mkOption {
            type = lib.types.package;
            readOnly = true;
            default = yaziFileChooserScript;
            description = "The yazi-file-chooser script package.";
          };
        };
      };
      default = { };
      description = "File chooser integration configuration.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.yazi = {
        enable = true;
        shellWrapperName = "yy";
        enableZshIntegration = config.terminal.zsh.enable;
        settings = {
          mgr = {
            show_hidden = true;
          };
        };
      };

      home.file.".local/share/icons/hicolor/scalable/apps/yazi.png" = {
        source = config.lib.file.mkOutOfStoreSymlink "${cfg.package}/share/pixmaps/yazi.png";
      };

      home.sessionVariables = {
        TERMCMD = lib.mkIf config.terminal.kitty.enable "${lib.getExe config.terminal.kitty.package} --class file-explorer --title 'Yazi'";
      };
    })
    (lib.mkIf (cfg.enable && config.terminal.kitty.enable) {
      xdg.desktopEntries."yazi" = {
        name = "Yazi";
        exec = "${lib.getExe config.terminal.kitty.package} --class yazi -e ${lib.getExe cfg.package}";
        icon = "yazi";
        categories = [ "Utility" ];
        comment = "Terminal file manager";
        terminal = false;
        type = "Application";
      };

      xdg.mimeApps.defaultApplications = {
        "inode/directory" = "yazi.desktop";
        "application/zip" = "yazi.desktop";
        "application/x-gzip" = "yazi.desktop";
        "application/x-tar" = "yazi.desktop";
        "application/x-7z-compressed" = "yazi.desktop";
        "application/x-rar-compressed" = "yazi.desktop";
      };
    })
    (lib.mkIf cfg.file-chooser.enable {
      home.file.".config/xdg-desktop-portal-termfilechooser/config" = {
        source = lib.getExe cfg.file-chooser.package;
      };
    })
  ];
}
