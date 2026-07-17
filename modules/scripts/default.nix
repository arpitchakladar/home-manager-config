# Scripts - Generates wrapped scripts with environment variables and dependencies
{
  config,
  lib,
  pkgs,
  ...
}:
let
  shell =
    if config.terminal.zsh.enable then (lib.getExe config.terminal.zsh.package) else "/usr/bin/env sh";

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

  # Script definitions: { path, env?, deps?, conditions? }
  # condition: attrset of { option (string path), value (expected value) }
  scriptDefs = {
    aria2-run = {
      path = ./aria2-run.sh;
      deps = [
        config.web.aria2.package
      ];
      conditions = [
        {
          option = "web.aria2.enable";
          value = true;
        }
      ];
    };
    deep-clean = {
      path = ./deep-clean.sh;
    };
    file-preview = {
      path = ./file-preview.sh;
      deps = [
        config.terminal.kitty.package
        config.terminal.bat.package
        config.media.ffmpeg.package
        config.file-management.ouch.package
        pkgs.file
        pkgs.librsvg
        pkgs.poppler-utils
      ];
      conditions = [
        {
          option = "media.ffmpeg.enable";
          value = true;
        }
        {
          option = "file-management.ouch.enable";
          value = true;
        }
        {
          # not a dependency
          option = "office.zathura.enable";
          value = true;
        }
        {
          option = "terminal.bat.enable";
          value = true;
        }
      ];
    };
    file-preview-clean = {
      path = ./file-preview-clean.sh;
      deps = [
        config.terminal.kitty.package
      ];
      conditions = [
        {
          option = "scripts.file-preview.enable";
          value = true;
        }
      ];
    };
    fzf-launcher = {
      path = ./fzf-launcher.sh;
      deps = [
        config.terminal.fzf.package
        pkgs.util-linux
        config.terminal.zsh.package
      ];
      conditions = [
        {
          option = "terminal.fzf.enable";
          value = true;
        }
        {
          option = "terminal.zsh.enable";
          value = true;
        }
      ];
    };
    i3-keybindings = {
      path = ./i3-keybindings.sh;
      conditions = [
        {
          option = "desktop.enable";
          value = true;
        }
      ];
    };
    screen-recording = {
      path = ./screen-recording.sh;
      deps = [
        config.media.ffmpeg.package
        config.media.slop.package
      ];
      conditions = [
        {
          option = "media.ffmpeg.enable";
          value = true;
        }
        {
          option = "media.slop.enable";
          value = true;
        }
      ];
    };
    system-monitor = {
      path = ./system-monitor.sh;
      deps = [
        config.system.bottom.package
        config.system.nvtop.package
        config.terminal.tmux.package
        config.terminal.kitty.package
      ];
      conditions = [
        {
          option = "system.bottom.enable";
          value = true;
        }
        {
          option = "system.nvtop.enable";
          value = true;
        }
        {
          option = "terminal.tmux.enable";
          value = true;
        }
        {
          option = "terminal.kitty.enable";
          value = true;
        }
      ];
    };
    vpn-connect = {
      path = ./vpn-connect.sh;
      env = {
        SYSTEMD_RESOLVED_PATH = "${config.security.openvpn.package}/libexec/update-systemd-resolved";
      };
      deps = [
        config.terminal.fzf.package
        config.security.openvpn.package
      ];
      conditions = [
        {
          option = "security.openvpn.enable";
          value = true;
        }
        {
          option = "terminal.fzf.enable";
          value = true;
        }
      ];
    };
    vpn-disconnect = {
      path = ./vpn-disconnect.sh;
      conditions = [
        {
          option = "scripts.vpn-connect.enable";
          value = true;
        }
      ];
    };
    neomutt-sync = {
      path = ./neomutt-sync.sh;
      deps = [
        pkgs.dialog
        config.programs.mbsync.package
        config.programs.notmuch.package
      ];
      conditions = [
        {
          option = "communication.neomutt.enable";
          value = true;
        }
      ];
    };
  };

  # Check whether all conditions for a script are satisfied
  conditionsMet =
    name: def:
    lib.all (cond: lib.attrByPath (lib.splitString "." cond.option) false config == cond.value) (
      def.conditions or [ ]
    );

  # Generate a .desktop entry that launches the script in kitty
  mkDesktopItem =
    name: def:
    let
      sc = config.scripts.${name};
    in
    if sc.enable && sc.desktop.enable then
      pkgs.makeDesktopItem {
        name = name;
        desktopName = sc.desktop.displayName;
        exec = "${lib.getExe config.terminal.kitty.package} -e ${lib.getExe sc.package}";
        icon = "kitty";
        categories = [ "Utility" ];
        terminal = false;
        type = "Application";
      }
    else
      null;

  desktopItems = lib.mapAttrsToList mkDesktopItem scriptDefs;

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
    desktop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to create a .desktop entry for this script.";
      };
      displayName = lib.mkOption {
        type = lib.types.str;
        default = name;
        description = "Display name for the .desktop entry.";
      };
    };
  }) scriptDefs;

  config = {
    # Wire up .package for each enabled script, with assertions for unmet conditions
    scripts =
      lib.recursiveUpdate
        (lib.mapAttrs (name: def: {
          package = lib.mkIf config.scripts.${name}.enable (
            mkScript name def.path (def.env or { }) (def.deps or [ ])
          );
        }) scriptDefs)
        {
          aria2-run.desktop = {
            enable = true;
            displayName = "Aria2 Download Manager";
          };
          i3-keybindings.desktop = {
            enable = true;
            displayName = "i3 Keybindings";
          };
          screen-recording.desktop = {
            enable = true;
            displayName = "Screen Recording";
          };
          system-monitor.desktop = {
            enable = true;
            displayName = "System Monitor";
          };
        };

    assertions = lib.concatLists (
      lib.mapAttrsToList (
        name: def:
        map (cond: {
          assertion =
            !config.scripts.${name}.enable
            || lib.attrByPath (lib.splitString "." cond.option) false config == cond.value;
          message = "scripts.${name} is enabled but requires `${cond.option} = ${builtins.toJSON cond.value}`.";
        }) (def.conditions or [ ])
      ) scriptDefs
    );

    home.packages = [
      pkgs.file
      config.terminal.bat.package
    ]
    ++ lib.filter (x: x != null) (lib.mapAttrsToList (_: s: s.package) config.scripts)
    ++ lib.filter (x: x != null) desktopItems;
  };
}
