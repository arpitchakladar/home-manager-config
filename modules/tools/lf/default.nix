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
      };

      previewer = {
        source = lib.getExe' pkgs.ctpv "ctpv";
      };

      extraConfig = ''
        &${lib.getExe' pkgs.ctpv "ctpv"} -s $id
        cmd on-quit %${lib.getExe' pkgs.ctpv "ctpv"} -e $id
        set cleaner ${lib.getExe' pkgs.ctpv "ctpvclear"}
      '';
    };

    home.file.".config/lf/icons".source = ./icons;
  };
}
