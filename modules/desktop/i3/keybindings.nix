{
  pkgs,
  lib,
  config,
}:

# Keybindings - i3 keyboard shortcuts (app launchers, vim directions, workspaces)
let
  mod = "Mod4";
in
{
  # --- General Applications ---
  "${mod}+r" =
    lib.mkIf (config.tools.fzf.enable && config.tools.kitty.enable)
      "exec ${lib.getExe pkgs.kitty} --class application-launcher -e ${lib.getExe config.scripts.fzf-launcher}";
  "${mod}+t" = lib.mkIf config.tools.kitty.enable "exec ${lib.getExe pkgs.kitty}";
  "${mod}+f" =
    lib.mkIf (config.tools.kitty.enable && config.tools.lf.enable)
      "exec ${lib.getExe pkgs.kitty} --title 'File Manager' --class file-explorer -e ${lib.getExe config.programs.lf.package}";
  "${mod}+s" =
    lib.mkIf config.tools.kitty.enable "exec ${lib.getExe pkgs.kitty} --title 'Keybindings' --class keybindings-viewer -e ${lib.getExe config.scripts.i3-keybindings}";
  "${mod}+q" = "kill";

  # --- Media / Hardware Keys ---
  "XF86MonBrightnessDown" =
    lib.mkIf config.tools.brightnessctl.enable "exec ${lib.getExe pkgs.brightnessctl} set 5%-";
  "XF86MonBrightnessUp" =
    lib.mkIf config.tools.brightnessctl.enable "exec ${lib.getExe pkgs.brightnessctl} set +5%";
  "XF86AudioLowerVolume" =
    lib.mkIf config.tools.pamixer.enable "exec ${lib.getExe pkgs.pamixer} --decrease 5";
  "XF86AudioRaiseVolume" =
    lib.mkIf config.tools.pamixer.enable "exec ${lib.getExe pkgs.pamixer} --increase 5";
  "XF86AudioMute" =
    lib.mkIf config.tools.pamixer.enable "exec ${lib.getExe pkgs.pamixer} --toggle-mute";
  "XF86AudioPlay" =
    lib.mkIf config.tools.playerctl.enable "exec ${lib.getExe pkgs.playerctl} play-pause";

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
    lib.mkIf config.tools.maim.enable "exec \"${lib.getExe pkgs.maim} -s | xclip -selection clipboard -t image/png\"";
  "${mod}+Shift+p" =
    lib.mkIf config.tools.maim.enable "exec \"mkdir -p ~/Pictures/Screenshots && ${lib.getExe pkgs.maim} -s ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png\"";
}
