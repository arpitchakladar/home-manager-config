{
  pkgs,
  lib,
  config,
  ...
}:

# Aria2 - command line download manager
{
  config = lib.mkIf config.programs.aria2.enable {
    programs.aria2 = {
      package = pkgs.aria2;
      settings = {
        dir = "${config.home.homeDirectory}/Downloads";
      };
    };
  };
}
