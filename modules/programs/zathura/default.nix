{
  config,
  lib,
  pkgs,
  ...
}:

# Zathura - Minimalistic document viewer (PDF, DJVU, etc.)
{
  config = lib.mkIf config.programs.zathura.enable {
    programs.zathura = {
      package = pkgs.zathura;
    };
  };
}
