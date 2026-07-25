{ config, ... }:
[
  {
    assertion = !config.scripts.screen-recording.enable || config.media.slurp.enable;
    message = "scripts.screen-recording is enabled but requires `media.slurp.enable`.";
  }
  {
    assertion = !config.scripts.screen-recording.enable || config.media.wf-recorder.enable;
    message = "scripts.screen-recording is enabled but requires `media.wf-recorder.enable`.";
  }
]
