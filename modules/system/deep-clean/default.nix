# Deep clean script for Nix systems
{
  config,
  lib,
  pkgs,
  ...
}:
let
  deepCleanScript = pkgs.writeShellApplication {
    name = "deep-clean";
    runtimeInputs = [ pkgs.bash ];
    text = builtins.readFile ./deep-clean.sh;
  };
in
{
  options.system.deep-clean = {
    enable = lib.mkEnableOption "Enables the deep-clean script.";

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = deepCleanScript;
      description = "The deep-clean script package.";
    };
  };

  config = lib.mkIf config.system.deep-clean.enable {
    home.packages = [ config.system.deep-clean.package ];
  };
}
