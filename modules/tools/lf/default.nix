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
      };

      previewer = {
        source = lib.getExe' pkgs.ctpv "ctpv";
      };

      extraConfig = ''
        &${lib.getExe' pkgs.ctpv "ctpv"} -s $id
        cmd on-quit %${lib.getExe' pkgs.ctpv "ctpv"} -e $id
        set cleaner ${lib.getExe' pkgs.ctpv "ctpvclear"}
        ${builtins.readFile ./lfrc}
      '';
    };

    home.file.".config/lf/icons".source = ./icons;
  };
}
