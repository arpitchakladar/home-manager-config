{
  config,
  lib,
  ...
}:
let
  workspaces = [
    {
      key = "1";
      workspace = "1";
    }
    {
      key = "2";
      workspace = "2";
    }
    {
      key = "3";
      workspace = "3";
    }
    {
      key = "4";
      workspace = "4";
    }
    {
      key = "5";
      workspace = "5";
    }
    {
      key = "6";
      workspace = "6";
    }
    {
      key = "7";
      workspace = "7";
    }
    {
      key = "8";
      workspace = "8";
    }
    {
      key = "9";
      workspace = "9";
    }
    {
      key = "0";
      workspace = "10";
    }
  ];

  workspaceBinds = builtins.foldl' lib.mergeAttrs { } (
    map (
      { key, workspace }:
      {
        "Mod+${key}".focus-workspace = [ workspace ];
        "Mod+Shift+${key}".move-column-to-workspace = [ workspace ];
      }
    ) workspaces
  );
in
{
  config.wayland.windowManager.niri.settings.binds = {
    "Mod+Shift+Slash".show-hotkey-overlay = { };

    "Mod+O" = {
      _props.repeat = false;
      toggle-overview = { };
    };
    "Mod+Shift+Q" = {
      _props.repeat = false;
      close-window = { };
    };
  }
  // workspaceBinds
  // (lib.optionalAttrs config.desktop.enable {
    "Mod+R" = {
      _props.hotkey-overlay-title = "Run an Application: rofi";
      spawn = [
        (lib.getExe config.desktop.rofi.package)
        "-show"
        "drun"
      ];
    };
  })
  // (lib.optionalAttrs config.terminal.kitty.enable {
    "Mod+Return" = {
      _props.hotkey-overlay-title = "Open a Terminal: kitty";
      spawn = [ (lib.getExe config.terminal.kitty.package) ];
    };
    "Mod+T".spawn = [ (lib.getExe config.terminal.kitty.package) ];
  })
  // (lib.optionalAttrs (config.terminal.kitty.enable && config.file-management.yazi.enable) {
    "Mod+F".spawn = [
      (lib.getExe config.terminal.kitty.package)
      "--class"
      "yazi"
      "--title"
      "Yazi"
      "-e"
      (lib.getExe config.file-management.yazi.package)
    ];
  })
  // {
    # Column-aware directional navigation.
    "Mod+H".focus-column-left = { };
    "Mod+L".focus-column-right = { };
    "Mod+Ctrl+H".move-column-left = { };
    "Mod+Ctrl+L".move-column-right = { };

    # Preserve the old Shift movement muscle memory as aliases.
    "Mod+Shift+H".move-column-left = { };
    "Mod+Shift+L".move-column-right = { };

    # Vim-style workspace scrolling.
    "Mod+J".focus-workspace-down = { };
    "Mod+K".focus-workspace-up = { };
    "Mod+Shift+J".move-column-to-workspace-down = { };
    "Mod+Shift+K".move-column-to-workspace-up = { };

    "Mod+D".toggle-window-floating = { };
    "Mod+V".toggle-window-floating = { };
    "Mod+M".fullscreen-window = { };
    "Mod+Equal".set-column-width = [ "+10%" ];
    "Mod+Minus".set-column-width = [ "-10%" ];
    "Mod+U".focus-workspace-down = { };
    "Mod+I".focus-workspace-up = { };
    "Mod+Ctrl+U".move-column-to-workspace-down = { };
    "Mod+Ctrl+I".move-column-to-workspace-up = { };
    "Mod+W".toggle-column-tabbed-display = { };
  }
  // (lib.optionalAttrs config.system.brightnessctl.enable {
    "XF86MonBrightnessDown" = {
      _props.allow-when-locked = true;
      spawn = [
        (lib.getExe config.system.brightnessctl.package)
        "set"
        "5%-"
      ];
    };
    "XF86MonBrightnessUp" = {
      _props.allow-when-locked = true;
      spawn = [
        (lib.getExe config.system.brightnessctl.package)
        "set"
        "+5%"
      ];
    };
  })
  // (lib.optionalAttrs config.media.pamixer.enable {
    "XF86AudioLowerVolume" = {
      _props.allow-when-locked = true;
      spawn = [
        (lib.getExe config.media.pamixer.package)
        "--decrease"
        "5"
      ];
    };
    "XF86AudioRaiseVolume" = {
      _props.allow-when-locked = true;
      spawn = [
        (lib.getExe config.media.pamixer.package)
        "--increase"
        "5"
      ];
    };
    "XF86AudioMute" = {
      _props.allow-when-locked = true;
      spawn = [
        (lib.getExe config.media.pamixer.package)
        "--toggle-mute"
      ];
    };
  })
  // (lib.optionalAttrs config.media.playerctl.enable {
    "XF86AudioPlay" = {
      _props.allow-when-locked = true;
      spawn = [
        (lib.getExe config.media.playerctl.package)
        "play-pause"
      ];
    };
  })
  // (lib.optionalAttrs (config.media.grim.enable && config.media.slurp.enable) {
    "Mod+P".spawn-sh = [
      "${lib.getExe config.media.grim.package} -g \"$(${lib.getExe config.media.slurp.package})\" - | ${lib.getExe' config.desktop.wl-clipboard.package "wl-copy"}"
    ];
    "Mod+Shift+P".spawn-sh = [
      ''mkdir -p "$HOME/Pictures/Screenshots" && ${lib.getExe config.media.grim.package} -g "$(${lib.getExe config.media.slurp.package})" "$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"''
    ];
  });
}
