{
  pkgs,
  lib,
  config,
  ...
}:

# Htop - Interactive process viewer (using htop-vim version)
{
  options.tools.htop = {
    enable = lib.mkEnableOption "Enables htop.";
  };

  config = lib.mkIf config.tools.htop.enable {
    programs.htop = {
      enable = true;
      package = pkgs.htop-vim;
    };
  };
}
