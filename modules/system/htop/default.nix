{
  pkgs,
  lib,
  config,
  ...
}:

# Htop - Interactive process viewer (using htop-vim version)
{
  config = lib.mkIf config.programs.htop.enable {
    programs.htop = {
      package = pkgs.htop-vim;
    };
  };
}
