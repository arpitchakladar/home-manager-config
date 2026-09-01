# Text-based calendar and scheduling application
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.office.calcurse = {
    enable = lib.mkEnableOption "Enables calcurse.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.calcurse;
      description = "The calcurse package to use.";
    };
  };

  config = lib.mkIf config.office.calcurse.enable {
    home.packages = [ config.office.calcurse.package ];

    xdg.configFile."calcurse/conf" = {
      source = ./conf;
      force = true;
    };
  };
}
