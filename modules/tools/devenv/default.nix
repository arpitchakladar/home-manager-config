{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.tools.devenv = {
    enable = lib.mkEnableOption "Enables devenv.";
  };

  config =
    let
      shellIntegration = builtins.readFile ./alias.sh;
    in
    lib.mkIf config.tools.devenv.enable {
      home.packages = with pkgs; [
        devenv
      ];

      programs.zsh.initContent = lib.mkIf config.programs.zsh.enable (lib.mkAfter shellIntegration);
      programs.bash.initExtra = lib.mkIf config.programs.bash.enable (lib.mkAfter shellIntegration);
    };
}
