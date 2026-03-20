{
  config,
  lib,
  ...
}:

{
  config = {
    home.sessionPath = [
      "${config.home.homeDirectory}/scripts"
    ];

    home.file =
      let
        shellScript = path: {
          text = ''
            #!${
              if config.tools.zsh.enable then (lib.getExe config.programs.zsh.package) else "#!/usr/bin/env sh"
            }
            ${builtins.readFile path}
          '';
          executable = true;
        };
      in
      {
        "scripts/deep-clean" = shellScript ./deep-clean.sh;
        "scripts/system-monitor" = lib.mkIf (
          config.tools.bottom.enable
          && config.tools.nvtop.enable
          && config.tools.tmux.enable
          && config.tools.kitty.enable
        ) (shellScript ./system-monitor.sh);
      };
  };
}
