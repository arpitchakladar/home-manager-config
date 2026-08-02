# Htop - Interactive process viewer (using htop-vim version)
{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.system.htop = {
    enable = lib.mkEnableOption "Enables htop.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.htop.package;
      description = "The htop package to use.";
    };
  };

  config = lib.mkIf config.system.htop.enable {
    programs.htop = {
      enable = true;
      package = pkgs.htop-vim;
    };
  };
}
