# yazi - Terminal file manager with native previews
{ config, lib, ... }:
{
  imports = [ ./theme.nix ];

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

    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "yazi.desktop";
    };
  };
}
