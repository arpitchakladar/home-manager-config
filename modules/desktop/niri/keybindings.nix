{
  config,
  lib,
  ...
}:
let
  workspaceBinds =
    lib.concatMapStringsSep "\n"
      (
        { key, workspace }:
        ''
          Mod+${key} { focus-workspace "${workspace}"; }
          Mod+Shift+${key} { move-column-to-workspace "${workspace}"; }''
      )
      [
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
in
{
  config.wayland.windowManager.niri.extraConfig = ''
    binds {
      // Niri defaults retained alongside the established launch and close bindings.
      Mod+Shift+Slash { show-hotkey-overlay; }
      Mod+O repeat=false { toggle-overview; }
      Mod+Q repeat=false { close-window; }
      Mod+Shift+Q repeat=false { close-window; }

      ${lib.optionalString config.desktop.enable ''Mod+R hotkey-overlay-title="Run an Application: rofi" { spawn "${lib.getExe config.desktop.rofi.package}" "-show" "drun"; }''}
      ${lib.optionalString config.terminal.kitty.enable ''
        Mod+Return hotkey-overlay-title="Open a Terminal: kitty" { spawn "${lib.getExe config.terminal.kitty.package}"; }
        Mod+T { spawn "${lib.getExe config.terminal.kitty.package}"; }''}
      ${lib.optionalString (config.terminal.kitty.enable && config.file-management.yazi.enable)
        ''Mod+F { spawn "${lib.getExe config.terminal.kitty.package}" "--class" "yazi" "--title" "Yazi" "-e" "${lib.getExe config.file-management.yazi.package}"; }''
      }

      // Niri's column/window-aware directional navigation.
      Mod+H { focus-column-left; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }
      Mod+L { focus-column-right; }
      Mod+Ctrl+H { move-column-left; }
      Mod+Ctrl+J { move-window-down; }
      Mod+Ctrl+K { move-window-up; }
      Mod+Ctrl+L { move-column-right; }

      // Preserve the old Shift movement muscle memory as aliases.
      Mod+Shift+H { move-column-left; }
      Mod+Shift+J { move-window-down; }
      Mod+Shift+K { move-window-up; }
      Mod+Shift+L { move-column-right; }

      Mod+D { toggle-window-floating; }
      Mod+V { toggle-window-floating; }
      Mod+M { fullscreen-window; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+Minus { set-column-width "-10%"; }
      Mod+U { focus-workspace-down; }
      Mod+I { focus-workspace-up; }
      Mod+Ctrl+U { move-column-to-workspace-down; }
      Mod+Ctrl+I { move-column-to-workspace-up; }
      Mod+W { toggle-column-tabbed-display; }

      ${workspaceBinds}

      ${lib.optionalString config.system.brightnessctl.enable ''
        XF86MonBrightnessDown allow-when-locked=true { spawn "${lib.getExe config.system.brightnessctl.package}" "set" "5%-"; }
        XF86MonBrightnessUp allow-when-locked=true { spawn "${lib.getExe config.system.brightnessctl.package}" "set" "+5%"; }''}
      ${lib.optionalString config.media.pamixer.enable ''
        XF86AudioLowerVolume allow-when-locked=true { spawn "${lib.getExe config.media.pamixer.package}" "--decrease" "5"; }
        XF86AudioRaiseVolume allow-when-locked=true { spawn "${lib.getExe config.media.pamixer.package}" "--increase" "5"; }
        XF86AudioMute allow-when-locked=true { spawn "${lib.getExe config.media.pamixer.package}" "--toggle-mute"; }''}
      ${lib.optionalString config.media.playerctl.enable ''XF86AudioPlay allow-when-locked=true { spawn "${lib.getExe config.media.playerctl.package}" "play-pause"; }''}

      ${lib.optionalString (config.media.grim.enable && config.media.slurp.enable)
        ''
          Mod+P { spawn-sh "${lib.getExe config.media.grim.package} -g \"$(${lib.getExe config.media.slurp.package})\" - | ${lib.getExe' config.desktop.wl-clipboard.package "wl-copy"}"; }
          Mod+Shift+P { spawn-sh "mkdir -p \"$HOME/Pictures/Screenshots\" && ${lib.getExe config.media.grim.package} -g \"$(${lib.getExe config.media.slurp.package})\" \"$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png\""; }''
      }
    }
  '';
}
