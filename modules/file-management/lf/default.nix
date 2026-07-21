# lf - terminal file manager
{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.file-management.lf = {
    enable = lib.mkEnableOption "Enables lf.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.lf.overrideAttrs (old: {
        dontWrapQtApps = true;
        dontPatchShebangs = true;
      });
      description = "The lf package to use.";
    };
  };

  config = lib.mkIf config.file-management.lf.enable {
    assertions = [
      {
        assertion = config.scripts.file-preview.enable;
        message = "file-management.lf.enable requires scripts.file-preview.enable for file previews.";
      }
      {
        assertion = config.scripts.file-preview-clean.enable;
        message = "file-management.lf.enable requires scripts.file-preview-clean.enable to clear kitty previews.";
      }
    ];

    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "lf.desktop";
    };

    programs.lf = {
      enable = true;
      package = config.file-management.lf.package;
      settings = {
        number = true;
        icons = true;
        drawbox = true;
        hidden = true;
        preview = true;

        shell = config.home.sessionVariables.SHELL;
        ifs = "\n";
        scrolloff = "4";
        period = "1";
        incsearch = true;
        smartcase = true;
        info = "size";
        sortby = "natural";
        dirfirst = true;

        cleaner = lib.getExe config.scripts.file-preview-clean.package;
      };

      previewer = {
        source = lib.getExe config.scripts.file-preview.package;
      };

      extraConfig = builtins.readFile ./lfrc;
    };

    home.file.".config/lf/icons".source = ./icons;
  };
}
