# Htop - Interactive process viewer (using htop-vim version)
{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.system.htop = {
    enable = lib.mkEnableOption "Enables htop.";
  };

  config = lib.mkIf config.system.htop.enable {
    programs.htop = {
      enable = true;
      package = pkgs.htop-vim;
    };
  };
}
