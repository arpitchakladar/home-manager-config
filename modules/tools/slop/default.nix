{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.tools.slop = {
    enable = lib.mkEnableOption "Enables slop.";
  };

  config = lib.mkIf config.tools.slop.enable {
    home.packages = with pkgs; [
      slop
    ];
  };
}
