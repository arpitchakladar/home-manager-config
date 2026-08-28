{ config, ... }:
[
  {
    assertion = !config.system.system-monitor.enable || config.system.bottom.enable;
    message = "system.system-monitor is enabled but requires `system.bottom.enable`.";
  }
  {
    assertion = !config.system.system-monitor.enable || config.system.nvtop.enable;
    message = "system.system-monitor is enabled but requires `system.nvtop.enable`.";
  }
  {
    assertion = !config.system.system-monitor.enable || config.terminal.tmux.enable;
    message = "system.system-monitor is enabled but requires `terminal.tmux.enable`.";
  }
  {
    assertion = !config.system.system-monitor.enable || config.terminal.kitty.enable;
    message = "system.system-monitor is enabled but requires `terminal.kitty.enable`.";
  }
]
