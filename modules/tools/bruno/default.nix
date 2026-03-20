{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.tools.bruno = {
    enable = lib.mkEnableOption "Enables bruno.";
  };

  config = lib.mkIf config.tools.bruno.enable {
    home.packages = with pkgs; [
      bruno
    ];
  };
}
