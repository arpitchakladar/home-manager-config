{
  config,
  lib,
  ...
}:
let
  workspaces = [
    {
      key = "1";
      workspace = 1;
    }
    {
      key = "2";
      workspace = 2;
    }
    {
      key = "3";
      workspace = 3;
    }
    {
      key = "4";
      workspace = 4;
    }
    {
      key = "5";
      workspace = 5;
    }
    {
      key = "6";
      workspace = 6;
    }
    {
      key = "7";
      workspace = 7;
    }
    {
      key = "8";
      workspace = 8;
    }
    {
      key = "9";
      workspace = 9;
    }
    {
      key = "0";
      workspace = 10;
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

    "Mod+V".toggle-window-floating = { };
    "Mod+M".fullscreen-window = { };
    "Mod+Equal".set-column-width = [ "+10%" ];
    "Mod+Minus".set-column-width = [ "-10%" ];
    "Mod+R".switch-preset-column-width = { };
    "Mod+U".focus-workspace-down = { };
    "Mod+I".focus-workspace-up = { };
    "Mod+Ctrl+U".move-column-to-workspace-down = { };
    "Mod+Ctrl+I".move-column-to-workspace-up = { };
    "Mod+W".toggle-column-tabbed-display = { };

    # Screenshots
    "Mod+P".screenshot = { };
    "Mod+Shift+P".screenshot-screen = { };

    # Externel commnads
    "Mod+D" = {
      _props.hotkey-overlay-title = "Run an Application: rofi";
      spawn = [
        (lib.getExe config.desktop.rofi.package)
        "-show"
        "drun"
      ];
    };
    "Mod+Shift+E" = {
      _props.hotkey-overlay-title = "Run an Action: rofi";
      spawn = [
        (lib.getExe config.desktop.rofi.action.package)
      ];
    };
    "Mod+Return" = lib.mkIf config.terminal.kitty.enable {
      _props.hotkey-overlay-title = "Open a Terminal: kitty";
      spawn = [ (lib.getExe config.terminal.kitty.package) ];
    };
    "XF86MonBrightnessDown" = lib.mkIf config.system.brightnessctl.enable {
      _props.allow-when-locked = true;
      spawn = [
        (lib.getExe config.system.brightnessctl.package)
        "set"
        "5%-"
      ];
    };
    "XF86MonBrightnessUp" = lib.mkIf config.system.brightnessctl.enable {
      _props.allow-when-locked = true;
      spawn = [
        (lib.getExe config.system.brightnessctl.package)
        "set"
        "+5%"
      ];
    };
    "XF86AudioLowerVolume" = lib.mkIf config.media.pamixer.enable {
      _props.allow-when-locked = true;
      spawn = [
        (lib.getExe config.media.pamixer.package)
        "--decrease"
        "5"
      ];
    };
    "XF86AudioRaiseVolume" = lib.mkIf config.media.pamixer.enable {
      _props.allow-when-locked = true;
      spawn = [
        (lib.getExe config.media.pamixer.package)
        "--increase"
        "5"
      ];
    };
    "XF86AudioMute" = lib.mkIf config.media.pamixer.enable {
      _props.allow-when-locked = true;
      spawn = [
        (lib.getExe config.media.pamixer.package)
        "--toggle-mute"
      ];
    };
    "XF86AudioPlay" = lib.mkIf config.media.playerctl.enable {
      _props.allow-when-locked = true;
      spawn = [
        (lib.getExe config.media.playerctl.package)
        "play-pause"
      ];
    };
  }
  // workspaceBinds;
}
