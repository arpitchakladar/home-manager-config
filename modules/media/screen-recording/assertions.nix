{ config, ... }:
let
  cfg = config.media.screen-recording;
in
[
  {
    assertion = !cfg.enable || config.media.slurp.enable;
    message = "media.screen-recording is enabled but requires `media.slurp.enable`.";
  }
  {
    assertion = !cfg.enable || config.media.wf-recorder.enable;
    message = "media.screen-recording is enabled but requires `media.wf-recorder.enable`.";
  }
  {
    assertion = !cfg.enable || config.terminal.kitty.enable;
    message = ''
      media.screen-recording is enabled but terminal.kitty.enable is not.
      screen-recording's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
    '';
  }
]
