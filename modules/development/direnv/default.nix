# the development environment switcher
{
  config,
  lib,
  ...
}:
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

  config = lib.mkIf config.development.direnv.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
  };
}
