{
  pkgs,
  lib,
  config,
  ...
}:

# lf - terminal file manager
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
    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "lf.desktop";
    };

    home.packages = with pkgs; [
      busybox
    ];

    programs.lf = {
      enable = true;
      package = config.file-management.lf.package;
      settings = {
        number = true;
        icons = true;
        drawbox = true;
        hidden = true;
        preview = true;

        shell = "sh";
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

      extraConfig = ''
        ${builtins.readFile ./lfrc}
      '';
    };

    home.file.".config/lf/icons".source = ./icons;
  };
}
