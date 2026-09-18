# Z shell, extended bash with additional features and plugins
{
  config,
  lib,
  ...
}:
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

  config =
    let
      nixCommandWrappers = builtins.readFile ./nix-aliases.sh;
    in
    lib.mkIf config.terminal.zsh.enable {
      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
        history.path = "${config.xdg.cacheHome}/zsh/history";
        enableCompletion = true;
        initContent = builtins.replaceStrings [ "@@NIX_COMMAND_WRAPPERS@@" ] [ nixCommandWrappers ] (
          builtins.readFile ./init.sh
        );
      };

      home.sessionVariables.SHELL = "${lib.getExe config.terminal.zsh.package}";
    };
}
