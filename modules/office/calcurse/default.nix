# Text-based calendar and scheduling application
{
  config,
  lib,
  pkgs,
  ...
}:
let
  calcursePackage =
    if config.development.nixvim.enable then
      pkgs.symlinkJoin {
        name = "calcurse-wrapped";
        paths = [ pkgs.calcurse ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/calcurse --set PAGER "nvim"
        '';
        meta = pkgs.calcurse.meta // {
          mainProgram = "calcurse";
        };
      }
    else
      pkgs.calcurse;
in
{
  options.office.calcurse = {
    enable = lib.mkEnableOption "Enables calcurse.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = calcursePackage;
      description = "The calcurse package to use.";
    };
  };
  config = lib.mkIf config.office.calcurse.enable {
    home.packages = [ config.office.calcurse.package ];
    xdg.configFile."calcurse/conf" = {
      source = ./conf;
      force = true;
    };
    xdg.configFile."calcurse/keys" = {
      source = ./keys;
      force = true;
    };
  };
}
