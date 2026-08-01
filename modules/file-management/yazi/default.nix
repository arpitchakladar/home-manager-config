# yazi - Terminal file manager with native previews
{ config, lib, ... }:
{
  imports = [
    ./theme.nix
    ./assertions.nix
  ];

  options.file-management.yazi = {
    enable = lib.mkEnableOption "Enables yazi.";
    package = lib.mkOption {
      type = lib.types.package;
      default = config.programs.yazi.finalPackage;
      defaultText = lib.literalExpression "config.programs.yazi.finalPackage";
      description = "The yazi package to use. Defaults to the wrapped finalPackage from programs.yazi.";
    };
  };

  config = lib.mkIf config.file-management.yazi.enable {
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
    };
  };
}
