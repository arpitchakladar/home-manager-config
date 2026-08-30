# Terminal file manager with native previews
{
  config,
  lib,
  pkgs,
  ...
}:
let
  yaziFileChooserScript = pkgs.writeShellApplication {
    name = "yazi-file-chooser";
    runtimeInputs = [
      pkgs.bash
      config.file-management.yazi.package
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

    file-chooser = {
      enable = lib.mkEnableOption "Enables the yazi-file-chooser script.";
      package = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        default = yaziFileChooserScript;
        description = "The yazi-file-chooser script package.";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.file-management.yazi.enable {
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
        source = config.lib.file.mkOutOfStoreSymlink "${config.file-management.yazi.package}/share/pixmaps/yazi.png";
      };

      xdg.desktopEntries."yazi" = {
        name = "Yazi";
        exec = "${lib.getExe config.terminal.kitty.package} --class yazi -e ${lib.getExe config.file-management.yazi.package}";
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

      home.sessionVariables = {
        TERMCMD = lib.mkIf config.terminal.kitty.enable "${lib.getExe config.terminal.kitty.package} --class file-explorer --title 'Yazi'";
      };
    })
    (lib.mkIf config.file-management.yazi.file-chooser.enable {
      home.file.".config/xdg-desktop-portal-termfilechooser/config" = {
        source = lib.getExe config.file-management.yazi.file-chooser.package;
      };
    })
  ];
}
