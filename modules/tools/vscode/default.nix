{ config, lib, pkgs, ... }:

{
  options.tools.vscode = {
    enable = lib.mkEnableOption "Enables vscode.";
  };

  config = lib.mkIf config.tools.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
  };
}
