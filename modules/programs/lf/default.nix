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
      ctpv
    ];

    programs.lf = {
      settings = {
        number = true;
        icons = true;
        drawbox = true;
        hidden = true;
        preview = true;

        shell = lib.mkIf config.programs.zsh.enable (lib.getExe config.programs.zsh.package);
        shellopts = "'-eu'";
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
