{ config, ... }:
[
  {
    assertion = !config.scripts.i3-keybindings.enable || config.desktop.enable;
    message = "scripts.i3-keybindings is enabled but requires `desktop.enable`.";
  }
  {
    assertion = !config.scripts.i3-keybindings.enable || config.terminal.less.enable;
    message = "scripts.i3-keybindings is enabled but requires `terminal.less.enable`.";
  }
]
