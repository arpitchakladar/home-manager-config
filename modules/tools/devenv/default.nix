{ config, pkgs, lib, ... }:

{
  options.tools.devenv = {
    enable = lib.mkEnableOption "Enables devenv.";
  };

  config = let
    # Use --no-reload by default for devenv shell
    shellIntegration = ''
devenv() {
  for arg in "$@"; do
    if [[ "$arg" == "--reload" || "$arg" == "--no-reload" ]]; then
      command devenv "$@"
      return
    fi
  done

  command devenv "$@" --no-reload
}
'';
  in lib.mkIf config.tools.devenv.enable {
    home.packages = with pkgs; [
      devenv
    ];

    programs.zsh.initContent = lib.mkIf config.programs.zsh.enable
      (lib.mkAfter shellIntegration);
    programs.bash.initExtra = lib.mkIf config.programs.bash.enable
      (lib.mkAfter shellIntegration);
  };
}
