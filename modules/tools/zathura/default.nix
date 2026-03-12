{ config, lib, ... }:

{
  options.tools.zathura = {
    enable = lib.mkEnableOption "Enables zathura.";
  };

  config = lib.mkIf config.tools.zathura.enable {
    programs.zathura.enable = true;
  };
}
