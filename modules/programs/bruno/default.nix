{
  config,
  lib,
  pkgs,
  ...
}:

# Bruno - Open-source API client for testing HTTP endpoints
{
  options.programs.bruno = {
    enable = lib.mkEnableOption "Enables bruno.";
    package = lib.mkPackageOption pkgs "bruno" { };
  };

  config = lib.mkIf config.programs.bruno.enable {
    home.packages = [ config.programs.bruno.package ];
  };
}
