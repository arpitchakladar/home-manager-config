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
    name: path: env: deps:
    let
      envVars = lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "${n}=\"${toString v}\"") env);
      wrappedScript = pkgs.writeTextFile {
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
    pkgs.symlinkJoin {
      name = name;
      paths = [ wrappedScript ] ++ deps;
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${name} \
          --prefix PATH : ${lib.makeBinPath deps}
      '';
      meta.mainProgram = name;
    };

  # Script definitions: { path, env, deps, condition }
  # condition: attrset of { option (string path), value (expected value) }
  scriptDefs = {
    deep-clean = {
      path = ./deep-clean.sh;
      env = { };
      deps = [ ];
      conditions = [ ];
    };
    file-preview = {
      path = ./file-preview.sh;
      env = {
        BAT = lib.getExe config.programs.bat.package;
        FILE = lib.getExe pkgs.file;
        FFMPEG = lib.getExe' pkgs.ffmpeg-full "ffmpeg";
        FFPROBE = lib.getExe' pkgs.ffmpeg-full "ffprobe";
        OUCH = lib.getExe pkgs.ouch;
        PDFTOPPM = lib.getExe' pkgs.poppler-utils "pdftoppm";
      };
      deps = [
        config.programs.bat.package
        pkgs.file
        pkgs.ffmpeg-full
        pkgs.ouch
        pkgs.poppler-utils
      ];
      conditions = [
        {
          option = "tools.ffmpeg.enable";
          value = true;
        }
        {
          option = "tools.ouch.enable";
          value = true;
        }
        {
          # not a dependency
          option = "tools.zathura.enable";
          value = true;
        }
        {
          option = "tools.bat.enable";
          value = true;
        }
      ];
    };
    file-preview-clean = {
      path = ./file-preview-clean.sh;
      env = { };
      deps = [ config.programs.fzf.package ];
      conditions = [
        {
          option = "tools.fzf.enable";
          value = true;
        }
      ];
    };
    fzf-launcher = {
      path = ./fzf-launcher.sh;
      env = {
        FZF = lib.getExe config.programs.fzf.package;
        SETSID = lib.getExe' pkgs.util-linux "setsid";
      };
      deps = [
        config.programs.fzf.package
        pkgs.util-linux
      ];
      conditions = [
        {
          option = "tools.fzf.enable";
          value = true;
        }
      ];
    };
    i3-keybindings = {
      path = ./i3-keybindings.sh;
      env = { };
      deps = [ ];
      conditions = [
        {
          option = "desktop.enable";
          value = true;
        }
      ];
    };
    screen-recording = {
      path = ./screen-recording.sh;
      env = {
        FFMPEG = lib.getExe pkgs.ffmpeg-full;
        SLOP = lib.getExe pkgs.slop;
      };
      deps = [
        pkgs.ffmpeg-full
        pkgs.slop
      ];
      conditions = [
        {
          option = "tools.ffmpeg.enable";
          value = true;
        }
        {
          option = "tools.slop.enable";
          value = true;
        }
      ];
    };
    system-monitor = {
      path = ./system-monitor.sh;
      env = {
        BTM = lib.getExe pkgs.bottom;
        NVTOP = lib.getExe pkgs.nvtopPackages.full;
        TMUX = lib.getExe pkgs.tmux;
        KITTY = lib.getExe config.programs.kitty.package;
      };
      deps = [
        pkgs.bottom
        pkgs.nvtopPackages.full
        pkgs.tmux
        config.programs.kitty.package
      ];
      conditions = [
        {
          option = "tools.bottom.enable";
          value = true;
        }
        {
          option = "tools.nvtop.enable";
          value = true;
        }
        {
          option = "tools.tmux.enable";
          value = true;
        }
        {
          option = "tools.kitty.enable";
          value = true;
        }
      ];
    };
    vpn-connect = {
      path = ./vpn-connect.sh;
      env = {
        FZF = lib.getExe config.programs.fzf.package;
        OPENVPN = lib.getExe pkgs.openvpn;
        SYSTEMD_RESOLVED = "${pkgs.openvpn}/libexec/update-systemd-resolved";
      };
      deps = [
        config.programs.fzf.package
        pkgs.openvpn
      ];
      conditions = [
        {
          option = "tools.openvpn.enable";
          value = true;
        }
        {
          option = "tools.fzf.enable";
          value = true;
        }
      ];
    };
    vpn-disconnect = {
      path = ./vpn-disconnect.sh;
      env = { };
      deps = [ ];
      conditions = [
        {
          option = "tools.openvpn.enable";
          value = true;
        }
        {
          option = "tools.fzf.enable";
          value = true;
        }
      ];
    };
  };

  # Check whether all conditions for a script are satisfied
  conditionsMet =
    name: def:
    lib.all (
      cond: lib.attrByPath (lib.splitString "." cond.option) false config == cond.value
    ) def.conditions;

in
{
  options.scripts = lib.mapAttrs (name: def: {
    enable = lib.mkOption {
      type = lib.types.bool;
      # Auto-enable if all required tool options are satisfied
      default = conditionsMet name def;
      description = ''
        Whether to enable the ${name} script.
        Defaults to true when all required options are set.
      '';
    };
    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      readOnly = true;
      description = "The derivation for the ${name} script. Set automatically when enabled.";
    };
  }) scriptDefs;

  config = {
    # Wire up .package for each enabled script, with assertions for unmet conditions
    scripts = lib.mapAttrs (name: def: {
      package = lib.mkIf config.scripts.${name}.enable (mkScript name def.path def.env def.deps);
    }) scriptDefs;

    assertions = lib.concatLists (
      lib.mapAttrsToList (
        name: def:
        map (cond: {
          assertion =
            !config.scripts.${name}.enable
            || lib.attrByPath (lib.splitString "." cond.option) false config == cond.value;
          message = "scripts.${name} is enabled but requires `${cond.option} = ${builtins.toJSON cond.value}`.";
        }) def.conditions
      ) scriptDefs
    );

    home.packages = [
      pkgs.file
      config.programs.bat.package
    ]
    ++ lib.filter (x: x != null) (lib.mapAttrsToList (_: s: s.package) config.scripts);
  };
}
