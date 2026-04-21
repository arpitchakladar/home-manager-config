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
    programs.lf = {
      enable = true;
      settings = {
        number = true;
        icons = true;
        drawbox = true;
        hidden = true;
      };
    };
  };
}
