{ config, lib, pkgs, ... }:

{
  options.tools.steam = {
    enable = lib.mkEnableOption "Enables steam.";
  };

  config = lib.mkIf config.tools.steam.enable {
    home.packages = with pkgs; [
      steam
    ];
  };
}
