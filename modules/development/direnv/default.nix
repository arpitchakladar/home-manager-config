# the development environment switcher
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development.direnv;
in
{
  options.development.direnv = {
    enable = lib.mkEnableOption "Enables direnv.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.direnv.package;
      description = "The direnv package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = lib.mkIf config.terminal.zsh.enable true;
      enableBashIntegration = true;
      silent = false;
      nix-direnv = {
        enable = true;
      };
    };
  };
}
