# Z shell, extended bash with additional features and plugins
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.terminal.zsh;

  nixCommandWrappers = builtins.readFile ./nix-aliases.sh;
in
{
  options.terminal.zsh = {
    enable = lib.mkEnableOption "Enables zsh.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.zsh.package;
      description = "The zsh package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      history.path = "${config.xdg.cacheHome}/zsh/history";
      enableCompletion = true;
      initContent = builtins.replaceStrings [ "@@NIX_COMMAND_WRAPPERS@@" ] [ nixCommandWrappers ] (
        builtins.readFile ./init.sh
      );
    };

    home.sessionVariables.SHELL = "${lib.getExe cfg.package}";
  };
}
