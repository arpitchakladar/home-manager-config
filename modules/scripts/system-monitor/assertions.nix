{ config, ... }:
[
  {
    assertion = !config.scripts.system-monitor.enable || config.system.bottom.enable;
    message = "scripts.system-monitor is enabled but requires `system.bottom.enable`.";
  }
  {
    assertion = !config.scripts.system-monitor.enable || config.system.nvtop.enable;
    message = "scripts.system-monitor is enabled but requires `system.nvtop.enable`.";
  }
  {
    assertion = !config.scripts.system-monitor.enable || config.terminal.tmux.enable;
    message = "scripts.system-monitor is enabled but requires `terminal.tmux.enable`.";
  }
  {
    assertion = !config.scripts.system-monitor.enable || config.terminal.kitty.enable;
    message = "scripts.system-monitor is enabled but requires `terminal.kitty.enable`.";
  }
]
