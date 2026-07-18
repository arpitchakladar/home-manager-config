{ config, ... }:
[
  {
    assertion = !config.scripts.file-preview.enable || config.terminal.kitty.enable;
    message = "scripts.file-preview is enabled but requires `terminal.kitty.enable`.";
  }
  {
    assertion = !config.scripts.file-preview.enable || config.media.ffmpeg.enable;
    message = "scripts.file-preview is enabled but requires `media.ffmpeg.enable`.";
  }
  {
    assertion = !config.scripts.file-preview.enable || config.file-management.ouch.enable;
    message = "scripts.file-preview is enabled but requires `file-management.ouch.enable`.";
  }
  {
    assertion = !config.scripts.file-preview.enable || config.terminal.bat.enable;
    message = "scripts.file-preview is enabled but requires `terminal.bat.enable`.";
  }
]
