{
  config,
  lib,
  pkgs,
  ...
}:

let
  # name: Script name
  # path: Path to script file
  # env: (Optional) Attribute set of environment variables { KEY = "VALUE"; }
  mkScript =
    name: path: env:
    let
      # Generate the shell shebang based on your config
      shell =
        if config.tools.zsh.enable then (lib.getExe config.programs.zsh.package) else "/usr/bin/env sh";

      # Convert the 'env' attribute set into a string of "export KEY='VALUE'" lines
      envVars = lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "${n}=\"${toString v}\"") env);
    in
    pkgs.writeTextFile {
      name = name;
      executable = true;
      destination = "/bin/${name}";
      text = ''
        #!${shell}
        ${envVars}
        ${builtins.readFile path}
      '';
    };
in
{
  config = {
    home.packages = [
      # Always included (pass empty set {} if no env vars needed)
      (mkScript "deep-clean" ./deep-clean.sh { })

      # Conditional scripts
      (lib.mkIf (config.tools.ffmpeg.enable && config.tools.slop.enable) (
        mkScript "screen-recording" ./screen-recording.sh {
          FFMPEG = lib.getExe pkgs.ffmpeg-full;
          SLOP = lib.getExe pkgs.slop;
        }
      ))

      (lib.mkIf
        (
          config.tools.bottom.enable
          && config.tools.nvtop.enable
          && config.tools.tmux.enable
          && config.tools.kitty.enable
        )
        (
          mkScript "system-monitor" ./system-monitor.sh {
            BTM = lib.getExe pkgs.bottom;
            NVTOP = lib.getExe pkgs.nvtopPackages.full;
            TMUX = lib.getExe pkgs.tmux;
            KITTY = lib.getExe pkgs.kitty;
          }
        )
      )

      (lib.mkIf (config.tools.openvpn.enable && config.tools.fzf.enable) (
        mkScript "vpn-connect" ./vpn-connect.sh {
          FZF = lib.getExe pkgs.fzf;
          OPENVPN = lib.getExe pkgs.openvpn;
          SYSTEMD_RESOLVED = "${pkgs.openvpn}/libexec/update-systemd-resolved";
        }
      ))
    ];
  };
}
