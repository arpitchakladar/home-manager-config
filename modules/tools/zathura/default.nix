{ config, lib, ... }:

# Zathura - Minimalistic document viewer (PDF, DJVU, etc.)
{
  options.tools.zathura = {
    enable = lib.mkEnableOption "Enables zathura.";
  };

  config = lib.mkIf config.tools.zathura.enable {
    programs.zathura.enable = true;
  };
}
