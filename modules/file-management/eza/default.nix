# Modern ls replacement with icons and colors
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.file-management.eza;
in
{
  options.file-management.eza = {
    enable = lib.mkEnableOption "Enables eza.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.eza.package;
      defaultText = lib.literalExpression "config.programs.eza.package";
      description = "The eza package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.eza = {
      enable = true;
      icons = "always";
      colors = "always";
      git = config.development.git.enable;
      enableZshIntegration = config.terminal.zsh.enable;
      extraOptions = [
        "--all"
        "--git"
        "--group"
        "--group-directories-first"
        "--header"
        "--long"
      ];
    };
  };
}
