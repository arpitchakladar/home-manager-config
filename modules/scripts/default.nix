{
  config,
  lib,
  pkgs,
  ...
}:
let
  shell =
    if config.tools.zsh.enable then (lib.getExe config.programs.zsh.package) else "/usr/bin/env sh";

  mkScript =
    name: path: env:
    let
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

  scripts = {
    deep-clean = mkScript "deep-clean" ./deep-clean.sh { };

    fzf-launcher = lib.mkIf config.tools.fzf.enable (
      mkScript "fzf-launcher" ./fzf-launcher.sh {
        FZF = lib.getExe pkgs.fzf;
        SETSID = "${pkgs.util-linux}/bin/setsid";
      }
    );

    screen-recording = lib.mkIf (config.tools.ffmpeg.enable && config.tools.slop.enable) (
      mkScript "screen-recording" ./screen-recording.sh {
        FFMPEG = lib.getExe pkgs.ffmpeg-full;
        SLOP = lib.getExe pkgs.slop;
      }
    );

    system-monitor =
      lib.mkIf
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
        );

    vpn-connect = lib.mkIf (config.tools.openvpn.enable && config.tools.fzf.enable) (
      mkScript "vpn-connect" ./vpn-connect.sh {
        FZF = lib.getExe pkgs.fzf;
        OPENVPN = lib.getExe pkgs.openvpn;
        SYSTEMD_RESOLVED = "${pkgs.openvpn}/libexec/update-systemd-resolved";
      }
    );
  };
in
{
  options.scripts = lib.mapAttrs (
    name: _:
    lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = "Derivation for the ${name} script, or null if disabled.";
    }
  ) scripts;

  config = {
    scripts = scripts;

    home.packages = lib.filter (x: x != null) (lib.mapAttrsToList (_: v: lib.mkIf true v) scripts);
  };
}
