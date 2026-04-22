{
  pkgs,
  lib,
  config,
  ...
}:

# lf - terminal file manager
{
  options.tools.lf = {
    enable = lib.mkEnableOption "Enables lf.";
  };

  config = lib.mkIf config.tools.lf.enable {
    home.packages = with pkgs; [
      ctpv
    ];

    programs.lf = {
      enable = true;
      settings = {
        number = true;
        icons = true;
        drawbox = true;
        hidden = true;
        preview = true;

        shell = if config.tools.zsh.enable then lib.getExe pkgs.zsh else "bash";
        shellopts = "'-eu'";
        ifs = "\n";
        scrolloff = "4";
        period = "1";
        incsearch = true;
        smartcase = true;
        info = "size";
        sortby = "natural";
        dirfirst = true;

        cleaner = lib.getExe config.scripts.file-preview-clean;
      };

      previewer = {
        source = lib.getExe config.scripts.file-preview;
      };

      extraConfig = ''
        ${builtins.readFile ./lfrc}
      '';
    };

    home.file.".config/lf/icons".source = ./icons;
  };
}
