{ config, ... }:
[
  {
    assertion = !config.scripts.fzf-launcher.enable || config.terminal.fzf.enable;
    message = "scripts.fzf-launcher is enabled but requires `terminal.fzf.enable`.";
  }
]
