{ config, lib, ... }:

{
  options.tools.fastfetch = {
    enable = lib.mkEnableOption "Enables fastfetch.";
  };

  config = lib.mkIf config.tools.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
    };
  };
}
