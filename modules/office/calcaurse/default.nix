# Text-based calendar and scheduling application
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.office.calcaurse = {
    enable = lib.mkEnableOption "Enables calcurse.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.calcurse;
      description = "The calcurse package to use.";
    };
  };

  config = lib.mkIf config.office.calcaurse.enable {
    home.packages = [ config.office.calcaurse.package ];
  };
}
