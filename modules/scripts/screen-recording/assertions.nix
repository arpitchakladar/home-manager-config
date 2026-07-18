{ config, ... }:
[
  {
    assertion = !config.scripts.screen-recording.enable || config.media.ffmpeg.enable;
    message = "scripts.screen-recording is enabled but requires `media.ffmpeg.enable`.";
  }
  {
    assertion = !config.scripts.screen-recording.enable || config.media.slop.enable;
    message = "scripts.screen-recording is enabled but requires `media.slop.enable`.";
  }
]
