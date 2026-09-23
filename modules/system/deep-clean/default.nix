# Deep clean script for Nix systems
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.system.deep-clean;

  deepCleanScript = pkgs.writeShellApplication {
    name = "deep-clean";
    runtimeInputs = [ config.terminal.bash.package ];
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

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
