{
  pkgs,
  lib,
  config,
  ...
}:

# lf - terminal file manager
{
  config = lib.mkIf config.programs.lf.enable {
    home.packages = with pkgs; [
      busybox
    ];

    programs.lf = {
      package = pkgs.lf.overrideAttrs (old: {
        dontWrapQtApps = true;
        dontPatchShebangs = true;
      });

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
