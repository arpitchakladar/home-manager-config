# Keybindings - i3 keyboard shortcuts (app launchers, vim directions, workspaces)
{
  lib,
  config,
}:
let
  mod = "Mod4";
in
{
  # --- General Applications ---
  "${mod}+r" =
    lib.mkIf (config.terminal.fzf.enable && config.terminal.kitty.enable)
      "exec ${lib.getExe config.terminal.kitty.package} --class application-launcher -e ${lib.getExe config.scripts.fzf-launcher.package}";
  "${mod}+Return" =
    lib.mkIf config.terminal.kitty.enable "exec ${lib.getExe config.terminal.kitty.package}";
  "${mod}+f" =
    lib.mkIf (config.terminal.kitty.enable && config.file-management.yazi.enable)
      "exec ${lib.getExe config.terminal.kitty.package} --title 'Yazi' -e ${lib.getExe config.file-management.yazi.package}";
  "${mod}+s" =
    lib.mkIf config.terminal.kitty.enable "exec ${lib.getExe config.terminal.kitty.package} --title 'Keybindings' --class keybindings-viewer -e ${lib.getExe config.scripts.i3-keybindings.package}";
  "${mod}+q" = "kill";

  # --- Media / Hardware Keys ---
  "XF86MonBrightnessDown" =
    lib.mkIf config.system.brightnessctl.enable "exec ${lib.getExe config.system.brightnessctl.package} set 5%-";
  "XF86MonBrightnessUp" =
    lib.mkIf config.system.brightnessctl.enable "exec ${lib.getExe config.system.brightnessctl.package} set +5%";
  "XF86AudioLowerVolume" =
    lib.mkIf config.media.pamixer.enable "exec ${lib.getExe config.media.pamixer.package} --decrease 5";
  "XF86AudioRaiseVolume" =
    lib.mkIf config.media.pamixer.enable "exec ${lib.getExe config.media.pamixer.package} --increase 5";
  "XF86AudioMute" =
    lib.mkIf config.media.pamixer.enable "exec ${lib.getExe config.media.pamixer.package} --toggle-mute";
  "XF86AudioPlay" =
    lib.mkIf config.media.playerctl.enable "exec ${lib.getExe config.media.playerctl.package} play-pause";

  # --- Window Management (Vim-style) ---
  # Focus
  "${mod}+h" = "focus left";
  "${mod}+j" = "focus down";
  "${mod}+k" = "focus up";
  "${mod}+l" = "focus right";

  # Move/Swap
  "${mod}+Shift+h" = "move left";
  "${mod}+Shift+j" = "move down";
  "${mod}+Shift+k" = "move up";
  "${mod}+Shift+l" = "move right";

  # Resize
  "${mod}+Control+h" = "resize shrink width 20 px or 20 ppt";
  "${mod}+Control+j" = "resize grow height 20 px or 20 ppt";
  "${mod}+Control+k" = "resize shrink height 20 px or 20 ppt";
  "${mod}+Control+l" = "resize grow width 20 px or 20 ppt";

  # Layout Modes
  "${mod}+d" = "floating toggle";
  "${mod}+m" = "fullscreen toggle";

  # --- Workspaces ---
  # Switch to workspace
  "${mod}+1" = "workspace number 1";
  "${mod}+2" = "workspace number 2";
  "${mod}+3" = "workspace number 3";
  "${mod}+4" = "workspace number 4";
  "${mod}+5" = "workspace number 5";
  "${mod}+6" = "workspace number 6";
  "${mod}+7" = "workspace number 7";
  "${mod}+8" = "workspace number 8";
  "${mod}+9" = "workspace number 9";
  "${mod}+0" = "workspace number 10";

  # Move window to workspace
  "${mod}+Shift+1" = "move container to workspace number 1; workspace number 1";
  "${mod}+Shift+2" = "move container to workspace number 2; workspace number 2";
  "${mod}+Shift+3" = "move container to workspace number 3; workspace number 3";
  "${mod}+Shift+4" = "move container to workspace number 4; workspace number 4";
  "${mod}+Shift+5" = "move container to workspace number 5; workspace number 5";
  "${mod}+Shift+6" = "move container to workspace number 6; workspace number 6";
  "${mod}+Shift+7" = "move container to workspace number 7; workspace number 7";
  "${mod}+Shift+8" = "move container to workspace number 8; workspace number 8";
  "${mod}+Shift+9" = "move container to workspace number 9; workspace number 9";
  "${mod}+Shift+0" = "move container to workspace number 10; workspace number 10";

  # --- Screenshots ---
  "${mod}+p" =
    lib.mkIf config.media.maim.enable "exec \"${lib.getExe config.media.maim.package} -s | xclip -selection clipboard -t image/png\"";
  "${mod}+Shift+p" =
    lib.mkIf config.media.maim.enable "exec \"mkdir -p ~/Pictures/Screenshots && ${lib.getExe config.media.maim.package} -s ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png\"";
}
