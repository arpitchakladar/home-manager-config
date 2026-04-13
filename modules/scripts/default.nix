{
  config,
  lib,
  pkgs,
  ...
}:

# Scripts - Home directory shell scripts (deep-clean, screen-recording, system-monitor)
let
  mkScript =
    name: path:
    pkgs.writeShellScriptBin name ''
      #!${
        if config.tools.zsh.enable then (lib.getExe config.programs.zsh.package) else "#!/usr/bin/env sh"
      }
      ${builtins.readFile path}
    '';
in
{
  config = {
    home.packages = [
      # Always included
      (mkScript "deep-clean" ./deep-clean.sh)

      # Conditional scripts (requies some tools)
      (lib.mkIf (config.tools.ffmpeg.enable && config.tools.slop.enable) (
        mkScript "screen-recording" ./screen-recording.sh
      ))

      (lib.mkIf (
        config.tools.bottom.enable
        && config.tools.nvtop.enable
        && config.tools.tmux.enable
        && config.tools.kitty.enable
      ) (mkScript "system-monitor" ./system-monitor.sh))

      (lib.mkIf (config.tools.openvpn.enable && config.tools.fzf.enable) (
        pkgs.writeShellScriptBin "vpn-connect" ''
          #!${if config.tools.zsh.enable then (lib.getExe config.programs.zsh.package) else "/usr/bin/env sh"}

          # Inject Nix store paths as environment variables for the script to use
          export FZF_BIN="${lib.getExe pkgs.fzf}"
          export OPENVPN_BIN="${lib.getExe pkgs.openvpn}"
          export RESOLVED_BIN="${pkgs.openvpn}/libexec/update-systemd-resolved"

          ${builtins.readFile ./vpn-connect.sh}
        ''
      ))
    ];
  };
}
