{
  config,
  pkgs,
  lib,
  ...
}:

# Devenv - Developer environment tooling (Nix-based dev environments)
{
  options.programs.devenv = {
    enable = lib.mkEnableOption "Enables devenv.";
    package = lib.mkPackageOption pkgs "devenv" { };
  };

  config =
    let
      shellIntegration = builtins.readFile ./alias.sh;
    in
    lib.mkIf config.programs.devenv.enable {
      home.packages = [ config.programs.devenv.package ];

      programs.zsh.initContent = lib.mkIf config.programs.zsh.enable (lib.mkAfter shellIntegration);
      programs.bash.initExtra = lib.mkIf config.programs.bash.enable (lib.mkAfter shellIntegration);
    };
}
