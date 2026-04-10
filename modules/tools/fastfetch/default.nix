{ config, lib, ... }:

# Fastfetch - System information tool (like neofetch but faster)
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
