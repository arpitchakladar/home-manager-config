{
  config,
  lib,
  ...
}:
let
  lua = lib.generators.mkLuaInline;

  bind = key: dispatcher: {
    _args = [
      (lua "mainMod .. \" + ${key}\"")
      (lua dispatcher)
    ];
  };

  bindRawFlags = key: dispatcher: flags: {
    _args = [
      key
      (lua dispatcher)
      flags
    ];
  };

  execLua = cmd: "hl.dsp.exec_cmd(\"${cmd}\")";

  execLuaSingle = cmd: "hl.dsp.exec_cmd('${cmd}')";
in
{
  config.wayland.windowManager.hyprland.settings.bind = lib.flatten [
    # --- General Applications ---
    (lib.optionals config.desktop.rofi.enable [
      (bind "R" (execLua "${lib.getExe config.desktop.rofi.package} -show drun"))
    ])
    (lib.optionals config.terminal.kitty.enable [
      (bind "Return" (execLua "${lib.getExe config.terminal.kitty.package}"))
      (bind "S" (
        execLua "${lib.getExe config.terminal.kitty.package} --title 'Keybindings' --class keybindings-viewer -e ${lib.getExe config.scripts.i3-keybindings.package}"
      ))
    ])
    (lib.optionals (config.terminal.kitty.enable && config.file-management.yazi.enable) [
      (bind "F" (
        execLua "${lib.getExe config.terminal.kitty.package} --class file-explorer --title 'Yazi' -e ${lib.getExe config.file-management.yazi.package}"
      ))
    ])
    (bind "Q" "hl.dsp.window.close()")

    # --- Media / Hardware Keys ---
    (lib.optionals config.system.brightnessctl.enable [
      (bindRawFlags "XF86MonBrightnessDown"
        (execLuaSingle "${lib.getExe config.system.brightnessctl.package} set 5%-")
        {
          locked = true;
          repeating = true;
        }
      )
      (bindRawFlags "XF86MonBrightnessUp"
        (execLuaSingle "${lib.getExe config.system.brightnessctl.package} set +5%")
        {
          locked = true;
          repeating = true;
        }
      )
    ])
    (lib.optionals config.media.pamixer.enable [
      (bindRawFlags "XF86AudioLowerVolume"
        (execLuaSingle "${lib.getExe config.media.pamixer.package} --decrease 5")
        {
          locked = true;
          repeating = true;
        }
      )
      (bindRawFlags "XF86AudioRaiseVolume"
        (execLuaSingle "${lib.getExe config.media.pamixer.package} --increase 5")
        {
          locked = true;
          repeating = true;
        }
      )
      (bindRawFlags "XF86AudioMute"
        (execLuaSingle "${lib.getExe config.media.pamixer.package} --toggle-mute")
        {
          locked = true;
          repeating = true;
        }
      )
    ])
    (lib.optionals config.media.playerctl.enable [
      (bindRawFlags "XF86AudioPlay"
        (execLuaSingle "${lib.getExe config.media.playerctl.package} play-pause")
        {
          locked = true;
          repeating = true;
        }
      )
    ])

    # --- Window Management (Vim-style) ---
    (bind "H" "hl.dsp.focus({ direction = \"l\" })")
    (bind "J" "hl.dsp.focus({ direction = \"d\" })")
    (bind "K" "hl.dsp.focus({ direction = \"u\" })")
    (bind "L" "hl.dsp.focus({ direction = \"r\" })")

    (bind "SHIFT + H" "hl.dsp.window.move({ direction = \"l\" })")
    (bind "SHIFT + J" "hl.dsp.window.move({ direction = \"d\" })")
    (bind "SHIFT + K" "hl.dsp.window.move({ direction = \"u\" })")
    (bind "SHIFT + L" "hl.dsp.window.move({ direction = \"r\" })")

    (bind "CTRL + H" "hl.dsp.window.resize({ x = -20, y = 0 })")
    (bind "CTRL + J" "hl.dsp.window.resize({ x = 0, y = 20 })")
    (bind "CTRL + K" "hl.dsp.window.resize({ x = 0, y = -20 })")
    (bind "CTRL + L" "hl.dsp.window.resize({ x = 20, y = 0 })")

    (bind "D" "hl.dsp.window.float({ action = \"toggle\" })")
    (bind "M" "hl.dsp.window.fullscreen()")

    # --- Workspaces ---
    (bind "1" "hl.dsp.focus({ workspace = 1 })")
    (bind "2" "hl.dsp.focus({ workspace = 2 })")
    (bind "3" "hl.dsp.focus({ workspace = 3 })")
    (bind "4" "hl.dsp.focus({ workspace = 4 })")
    (bind "5" "hl.dsp.focus({ workspace = 5 })")
    (bind "6" "hl.dsp.focus({ workspace = 6 })")
    (bind "7" "hl.dsp.focus({ workspace = 7 })")
    (bind "8" "hl.dsp.focus({ workspace = 8 })")
    (bind "9" "hl.dsp.focus({ workspace = 9 })")
    (bind "0" "hl.dsp.focus({ workspace = 10 })")

    (bind "SHIFT + 1" "hl.dsp.window.move({ workspace = 1 })")
    (bind "SHIFT + 2" "hl.dsp.window.move({ workspace = 2 })")
    (bind "SHIFT + 3" "hl.dsp.window.move({ workspace = 3 })")
    (bind "SHIFT + 4" "hl.dsp.window.move({ workspace = 4 })")
    (bind "SHIFT + 5" "hl.dsp.window.move({ workspace = 5 })")
    (bind "SHIFT + 6" "hl.dsp.window.move({ workspace = 6 })")
    (bind "SHIFT + 7" "hl.dsp.window.move({ workspace = 7 })")
    (bind "SHIFT + 8" "hl.dsp.window.move({ workspace = 8 })")
    (bind "SHIFT + 9" "hl.dsp.window.move({ workspace = 9 })")
    (bind "SHIFT + 0" "hl.dsp.window.move({ workspace = 10 })")

    # --- Screenshots ---
    (bind "P" (execLuaSingle "grim -g \"$(slurp)\" - | wl-copy"))
    (bind "SHIFT + P" (
      execLuaSingle "mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
    ))
  ];
}
