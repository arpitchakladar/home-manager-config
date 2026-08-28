{ config, ... }:
[
  {
    assertion = !config.media.screen-recording.enable || config.media.slurp.enable;
    message = "media.screen-recording is enabled but requires `media.slurp.enable`.";
  }
  {
    assertion = !config.media.screen-recording.enable || config.media.wf-recorder.enable;
    message = "media.screen-recording is enabled but requires `media.wf-recorder.enable`.";
  }
]
